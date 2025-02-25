import { ILocation } from "../interfaces/location-interface";
import { IReminder } from "../interfaces/reminder-interface";
import { TriggerType } from "../interfaces/trigger-interface";

/**
 *
 * @param reminders List of reminders to check
 * @param location Current location of the user to check against
 * @returns List of objects containing the reminder and the message for each reminder that should be triggered.
 */
export async function getRemindersToTrigger(
  reminders: IReminder[],
  location: ILocation
): Promise<{ reminder: IReminder; message: string }[]> {
  const out: { reminder: IReminder; message: string }[] = [];

  for (const reminder of reminders) {
    // Reminders with no trigger cannot be triggered
    if (!reminder.trigger) {
      continue;
    }

    switch (reminder.trigger) {
      case TriggerType.WEATHER:
        out.push({ reminder, message: "Weather reminder, bad weather" });
      case TriggerType.TFL:
      // Check TFL
      case TriggerType.TRAFFIC:
      // Check traffic
      case TriggerType.GROCERY:
      // Check grocery
      case TriggerType.PHARMACY:
      // Check pharmacy
      case TriggerType.CUSTOMLOCATION:
      // Check custom location
      default:
        break;
    }
  }

  return out;
}
