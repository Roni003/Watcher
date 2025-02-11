import { ILocation } from "./location-interface";
import { IReminderTrigger } from "./trigger-interface";

export interface IReminder {
  id: string;
  description: string;
  date: Date;
  location?: ILocation;
  radius?: number; // meters
  trigger?: IReminderTrigger;
}
