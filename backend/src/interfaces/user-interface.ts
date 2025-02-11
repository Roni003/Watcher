import { TriggerType } from "./trigger-interface";

export interface IUser {
  id: string;
  // Decide login method
  //   email: string;
  //   password: string;
  // phone: string;
  createdAt: Date;
  // For each trigger type, store a list of blacklisted location names
  blacklist: Map<TriggerType, Array<string>>;
}
