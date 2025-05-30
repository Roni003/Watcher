import config from "../config/config";
import { ILocation } from "../interfaces/location-interface";
import {
  IReminder,
  ReminderMetadata,
  TflMetadata,
} from "../interfaces/reminder-interface";
import { TriggerType } from "../interfaces/trigger-interface";
import { getNearbyPlaces } from "../services/map-service";
import { fetchTFLInfo } from "../services/tfl-service";
import { fetchTrafficData } from "../services/traffic-service";
import { getUserById } from "../services/user-service";
import { fetchCurrentWeatherInfo } from "../services/weather-service";
import { doesLineHaveGoodService } from "./tfl";
import {
  aggregateTrafficData,
  interpretConfidence,
  interpretJamFactor,
} from "./traffic";
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
        const trafficResult = await handleTraffic(location, reminder);
        if (trafficResult) {
          out.push(trafficResult);
        }
        break;
      case TriggerType.GROCERY:
        const groceryResult = await handleNearbyPlace(
          location,
          reminder,
          "supermarket"
        );
        if (groceryResult) {
          out.push(groceryResult);
        }
        break;
      case TriggerType.PHARMACY:
        const pharmacyResult = await handleNearbyPlace(
          location,
          reminder,
          "pharmacy"
        );
        if (pharmacyResult) {
          out.push(pharmacyResult);
        }
        break;
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

async function handleNearbyPlace(
  location: ILocation,
  reminder: IReminder,
  placeName: string
) {
  const { data, error } = await getUserById(reminder.user_id);
  if (error) {
    console.error(
      "Error fetching user during grocery store trigger check",
      error
    );
    return;
  }

  const radius = data.radius;
  const maxResults = 3;
  const nearbyPlaces = await getNearbyPlaces(
    location,
    radius,
    [placeName],
    maxResults
  );

  if (!nearbyPlaces.places || nearbyPlaces.places.length === 0) {
    return;
  }

  return {
    reminder,
    message: `Nearby (${radius}m) ${placeName} found: ${nearbyPlaces.places[0].displayName.text}`,
  };
}

async function handleTraffic(location: ILocation, reminder: IReminder) {
  const { data, error } = await getUserById(reminder.user_id);
  if (error) {
    console.error(
      "Error fetching user during grocery store trigger check",
      error
    );
    return;
  }

  const radius = data.radius;
  const { data: trafficData, error: trafficError } = await fetchTrafficData(
    location,
    radius
  );
  if (!trafficData || trafficError) {
    return;
  }

  const aggergatedData = aggregateTrafficData(trafficData);
  const interpretedJamFactor = interpretJamFactor(
    aggergatedData.averageJamFactor
  );
  const interpretedConfidence = interpretConfidence(
    aggergatedData.averageConfidence
  );

  if (
    aggergatedData.averageJamFactor >
    config.TRAFFIC_JAM_FACTOR_TRIGGER_THRESHOLD
  ) {
    return {
      reminder,
      message: `Traffic jam detected: ${interpretedJamFactor} (${radius}m) | ${interpretedConfidence}`,
    };
  }
}
