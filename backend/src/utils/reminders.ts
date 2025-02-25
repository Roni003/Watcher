import { ILocation } from "../interfaces/location-interface";
import { IReminder } from "../interfaces/reminder-interface";
import { TriggerType } from "../interfaces/trigger-interface";

export async function getRemindersToTrigger(
  reminders: IReminder[],
  location: ILocation
): Promise<IReminder[]> {
  const out: IReminder[] = [];

  for (const reminder of reminders) {
    // Reminders with no trigger cannot be triggered
    if (!reminder.trigger) {
      continue;
    }

    switch (reminder.trigger) {
      case TriggerType.WEATHER:
      // Check weather
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
