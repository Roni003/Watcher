import { ILocation } from "../interfaces/location-interface";
import {
  IReminder,
  ReminderMetadata,
  TflMetadata,
} from "../interfaces/reminder-interface";
import { TriggerType } from "../interfaces/trigger-interface";
import { fetchTFLInfo } from "../services/tfl-service";
import { fetchCurrentWeatherInfo } from "../services/weather-service";
import { doesLineHaveGoodService } from "./tfl";
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

    // Only check enabled reminders
    if (!reminder.enabled) {
      continue;
    }

    switch (reminder.trigger) {
      case TriggerType.WEATHER:
        const weatherResult = await handleWeather(location, reminder);
        if (weatherResult) {
          out.push(weatherResult);
        }
        break;
      case TriggerType.TFL:
        const tflResult = await handleTFL(location, reminder);
        if (tflResult) {
          out.push(tflResult);
        }
        break;
      case TriggerType.TRAFFIC:
        // Check traffic
        break;
      case TriggerType.GROCERY:
        // Check grocery
        break;
      case TriggerType.PHARMACY:
        // Check pharmacy
        break;
      // case TriggerType.CUSTOMLOCATION:
      // Check custom location
      // break;
      default:
        break;
    }
  }

  return out;
}

async function handleWeather(location: ILocation, reminder: IReminder) {
  const { data, error } = await fetchCurrentWeatherInfo(location);
  if (error) {
    console.error("[Error fetching weather]", error);
    return;
  }

  const weatherCondition = data?.weather[0].main;
  let weatherMessage =
    data?.weather[0].description || "No description available";
  if (weatherMessage && data?.name) {
    weatherMessage += ` in ${data.name}`;
  }
  if (weatherCondition && isBadWeather(weatherCondition)) {
    return {
      reminder,
      message: weatherMessage,
    };
  }
}

async function handleTFL(location: ILocation, reminder: IReminder) {
  if (!reminder.metadata) {
    console.log("No metadata specified for TFL reminder, skipping");
    return;
  }

  const metadata = reminder.metadata as TflMetadata;
  if ((metadata as TflMetadata).line == undefined) {
    console.log("No line specified for TFL reminder, skipping");
    return;
  }

  const line = (metadata as TflMetadata).line;
  const { data: tflData, error: tflError } = await fetchTFLInfo(line);
  if (tflError || !tflData?.lineStatuses) {
    console.error("[Error fetching TFL info]", tflError);
    return;
  }

  const stasus = tflData?.lineStatuses[0];
  const message = `${stasus.statusSeverityDescription} on ${tflData.name} line`;

  if (doesLineHaveGoodService(tflData)) {
    return;
  }

  // Only push those with bad service
  return {
    reminder,
    message,
  };
}
