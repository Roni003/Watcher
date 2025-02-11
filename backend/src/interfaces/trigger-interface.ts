// This file contains all the interfaces types for
// location based triggers for reminders.

export type TriggerType =
  | "weather"
  | "grocery"
  | "traffic"
  | "pharmacy"
  | "tfl"
  | "clothing"
  | "cafe";

interface IReminderTriggerBase {
  type: TriggerType;
}

export interface WeatherTrigger extends IReminderTriggerBase {
  type: "weather";
}

export interface GroceryTrigger extends IReminderTriggerBase {
  type: "grocery";
}

export interface TrafficTrigger extends IReminderTriggerBase {
  type: "traffic";
}

export interface PharmacyTrigger extends IReminderTriggerBase {
  type: "pharmacy";
}

// Trigger for TFL (Transport for London) delays.
export interface TflTrigger extends IReminderTriggerBase {
  type: "tfl";
  line: string;
}

export interface ClothingTrigger extends IReminderTriggerBase {
  type: "clothing";
}

export interface CafeTrigger extends IReminderTriggerBase {
  type: "cafe";
}

export type IReminderTrigger =
  | WeatherTrigger
  | GroceryTrigger
  | TrafficTrigger
  | PharmacyTrigger
  | TflTrigger
  | ClothingTrigger
  | CafeTrigger;
