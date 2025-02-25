import { Request, Response } from "express";
import {
  getRemindersForUser,
  getRemindersById,
  deleteReminderById,
  createNewReminder,
} from "../services/reminder-service";
import { IReminder } from "../interfaces/reminder-interface";

export async function getReminders(req: Request, res: Response) {
  try {
    const { data: reminders, error } = await getRemindersForUser(req.user.id);

    if (error) {
      console.error("[Error getting reminders]", error);
      res.status(500).json({
        error: "Error getting reminders",
        status: 500,
      });
      return;
    }

    if (!reminders) {
      res.status(200).json([]);
      return;
    }

    res.status(200).json(reminders);
  } catch (error) {
    console.error("[Error getting reminders]", error);
    res.status(500).json({
      error: "Error getting reminders",
      status: 500,
    });
  }
}

export async function createReminder(req: Request, res: Response) {
  const reminderData: IReminder = req.body;
  const userId: string = req.user.id;

  const { data, error } = await createNewReminder(reminderData, userId);
  if (error) {
    console.error("[Error creating reminder] " + error);
    res.status(400).json({ error: error.message });
    return;
  }

  res.json({ message: "Reminder created successfully", reminder: data });
}

export async function deleteReminder(req: Request, res: Response) {
  const reminderId: string = req.params.id;
  const userId: string = req.user.id;

  const { data, error } = await getRemindersById(reminderId, userId);
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

export async function checkReminderTriggers(req: Request, res: Response) {
  if (!req.body.location) {
    res.status(400).json({ error: "Location is required" });
    return;
  }

  const { location } = req.body;

  const { data: reminders, error } = await getRemindersForUser(req.user.id);
  if (error) {
    res.status(500).json({ error: "Error getting reminders" });
    return;
  }

  console.log(location);

  res.json({ reminders });
}
