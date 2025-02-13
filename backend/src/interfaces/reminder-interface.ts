import { Serializable } from "child_process";
import { ILocation } from "./location-interface";
import { IReminderTrigger } from "./trigger-interface";

export interface IReminder {
  id: string;
  description: string;
  created_at: Date;
  location?: ILocation;
  trigger?: IReminderTrigger;
}
