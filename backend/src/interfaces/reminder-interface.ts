import { ILocation } from "./location-interface";
import { TriggerType } from "./trigger-interface";

export interface IReminder {
  id: string;
  description: string;
  created_at: Date;
  location?: ILocation;
  trigger?: TriggerType;
}
