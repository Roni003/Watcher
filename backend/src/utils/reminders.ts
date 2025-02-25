import { ILocation } from "../interfaces/location-interface";
import { IReminder } from "../interfaces/reminder-interface";
import { TriggerType } from "../interfaces/trigger-interface";
import { fetchWeatherInfo } from "../services/weather-service";
import { isBadWeather } from "./weather";

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
        const { data, error } = await fetchWeatherInfo(location);
        if (error) {
          console.error("[Error fetching weather]", error);
          continue;
        }

        const weatherCondition = data?.weather[0].main;
        let message =
          data?.weather[0].description || "No description available";
        if (message && data?.name) {
          message += ` in ${data.name}`;
        }
        if (weatherCondition && isBadWeather(weatherCondition)) {
          out.push({
            reminder,
            message,
          });
        }
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
