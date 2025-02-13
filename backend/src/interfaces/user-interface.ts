import { TriggerType } from "./trigger-interface";

export interface IUser {
  id: string;
  email: string;
  createdAt: Date;
  // For each trigger type, store a list of blacklisted location names
  blacklist: Map<TriggerType, Array<string>>;
  radius: number; // Trigger radius for ALL reminders in meters
}
