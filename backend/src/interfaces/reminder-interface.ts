import { ILocation } from "./location-interface";
import { TriggerType } from "./trigger-interface";

export interface CustomLocationMetadata {
  location: ILocation;
}

export interface TflMetadata {
  line: string;
}

// Union type for all possible metadata
export type ReminderMetadata = CustomLocationMetadata | TflMetadata | {};

export interface IReminder {
  id: string;
  user_id: string;
  description: string;
  created_at: string;
  updated_at?: string;
  trigger?: TriggerType;
  metadata?: ReminderMetadata; // JSON stringified metadata
}
