import { Request, Response } from "express";
import { getRemindersForUser } from "../services/reminder-service";
import { IReminder } from "../interfaces/reminder-interface";

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
