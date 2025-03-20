import { TriggerType } from "./trigger-interface";

export interface IUser {
  id: string;
  email: string;
  created_at: Date;
  updated_at?: Date;
  radius: number; // Trigger radius for ALL reminders in meters
  fetch_interval: number; // Interval in seconds
  battery_saver_mode: boolean;
  // For each trigger type, store a list of blacklisted location names
  blacklist: Map<TriggerType, Array<string>>;
}
