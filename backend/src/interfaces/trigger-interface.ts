// This file contains all the interfaces types for
// location based triggers for reminders.

export type TriggerType =
  | "weather"
  | "traffic"
  | "tfl"
  | "groceryStore"
  | "pharmacy"
  | "customLocation";

interface IReminderTriggerBase {
  type: TriggerType;
}

export interface WeatherTrigger extends IReminderTriggerBase {
  type: "weather";
}

export interface TrafficTrigger extends IReminderTriggerBase {
  type: "traffic";
}

// Trigger for TFL (Transport for London) delays.
export interface TflTrigger extends IReminderTriggerBase {
  type: "tfl";
  line: string;
}
export interface GroceryTrigger extends IReminderTriggerBase {
  type: "groceryStore";
}
export interface PharmacyTrigger extends IReminderTriggerBase {
  type: "pharmacy";
}

export interface CustomLocationTrigger extends IReminderTriggerBase {
  type: "customLocation";
}

export type IReminderTrigger =
  | WeatherTrigger
  | TrafficTrigger
  | TflTrigger
  | GroceryTrigger
  | PharmacyTrigger
  | CustomLocationTrigger;
