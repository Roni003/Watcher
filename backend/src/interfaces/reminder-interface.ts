import { ILocation } from "./location-interface";
import { TriggerType } from "./trigger-interface";

export interface CustomLocationMetadata {
  location: ILocation;
}

export interface TflMetadata {
  line: string;
}

// Union type for all possible metadata
export type ReminderMetadata = CustomLocationMetadata | TflMetadata;

export interface IReminder {
  id: string;
  description: string;
  created_at: Date;
  trigger?: TriggerType;
  metadata?: ReminderMetadata;
}
