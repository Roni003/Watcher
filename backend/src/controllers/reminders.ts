import { Request, Response } from "express";
import {
  getRemindersForUser,
  getReminderById,
  deleteReminderById,
} from "../services/reminder-service";
import { IReminder } from "../interfaces/reminder-interface";
import supabaseClient from "../services/supabase";

export async function getReminders(req: Request, res: Response) {
  try {
    const { data: reminders, error } = await getRemindersForUser(req.user.id);
    if (error || !reminders) {
      console.error("[Error getting reminders] " + error);
      res.status(500).send("Error getting reminders");
      return;
    }
    const formattedReminders: IReminder[] = [];
    for (const reminder of reminders) {
      formattedReminders.push({
        id: reminder.id,
        description: reminder.description,
        created_at: reminder.created_at,
        location: reminder.location_lat
          ? { lat: reminder.location_lat, lon: reminder.location_lon }
          : undefined,
        trigger: reminder.trigger ? reminder.trigger : undefined,
      });
    }
    res.send(formattedReminders);
  } catch (error) {
    console.error("[Error getting reminders] " + error);
    res.status(500).send("Error getting reminders");
  }
}

export async function createReminder(req: Request, res: Response) {
  // Get reminder data from request body
  // Validate reminder data
  // Create reminder in database
  // Return reminder data
}

export async function deleteReminder(req: Request, res: Response) {
  // Get reminder id from request params
  // Delete reminder from database
  // Return success message
  const reminderId: string = req.params.id;
  const userId: string = req.user.id;

  const { data, error } = await getReminderById(reminderId, userId);
  if (error) {
    console.error("[Error deleting reminder] " + error);
    res.status(500).json({ error: error.message });
    return;
  }

  if (!data || data.length === 0) {
    res.status(404).json({ error: `Reminder with id=${reminderId} not found` });
    return;
  }

  const { error: err } = await deleteReminderById(reminderId, userId);
  if (err) {
    console.error("[Error deleting reminder] " + err);
    res.status(500).json({ error: err.message });
    return;
  }

  res.send({ message: "Reminder deleted successfully", reminderId });
}
