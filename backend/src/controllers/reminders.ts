import { Request, Response } from "express";
import { getRemindersForUser } from "../services/reminder-service";
import { IReminder } from "../interfaces/reminder-interface";
import supabaseClient from "../services/supabase";

export async function getReminders(req: Request, res: Response) {
  try {
    const reminders = await getRemindersForUser(req.user.id);
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

  // Check if reminder exists
  const { data, error } = await supabaseClient
    .from("reminders")
    .select("*")
    .eq("id", reminderId)
    .eq("user_id", userId);

  if (error) {
    console.error("[Error finding reminder] " + error.message);
    res.status(500).json({ error: error.message });
    return;
  }

  if (data.length === 0) {
    res
      .status(404)
      .json({ error: "Reminder not found with id: " + reminderId });
    return;
  }

  const response = await supabaseClient
    .from("reminders")
    .delete()
    .eq("id", reminderId)
    .eq("user_id", userId);

  if (response.error) {
    console.error("[Error deleting reminder] " + response.error.message);
    res.status(500).json({ error: response.error.message });
    return;
  }

  res.send({ message: "Reminder deleted successfully", reminderId });
}
