import { IReminder } from "../interfaces/reminder-interface";
import { TriggerType } from "../interfaces/trigger-interface";
import supabaseClient from "./supabase";

export async function getRemindersForUser(userId: string) {
  const { data, error } = await supabaseClient
    .from("reminders")
    .select("*")
    .eq("user_id", userId);

  return { data, error };
}

export async function getReminderById(reminderId: string, userId: string) {
  const { data, error } = await supabaseClient
    .from("reminders")
    .select("*")
    .eq("id", reminderId)
    .eq("user_id", userId);

  return { data, error };
}

export async function createNewReminder(
  reminderData: Omit<IReminder, "id" | "created_at">,
  userId: string
) {
  // If there is a trigger, check if trigger type is valid
  if (
    reminderData.trigger &&
    !Object.values(TriggerType).includes(reminderData.trigger)
  ) {
    return {
      error: new Error(
        "Invalid trigger type, must be one of the TriggerType: " +
          Object.values(TriggerType).join(", ")
      ),
    };
  }

  // Convert location coordinates to numbers if they exist
  const location = reminderData.location
    ? {
        lat: Number(reminderData.location.lat),
        lon: Number(reminderData.location.lon),
      }
    : undefined;

  if (
    (location && reminderData.trigger != TriggerType.CustomLocation) ||
    ((!location?.lat || !location.lon) &&
      reminderData.trigger == TriggerType.CustomLocation)
  ) {
    return {
      error: new Error(
        "Invalid trigger type to use a custom given location, trigger type must be customLocation"
      ),
    };
  }

  const { data, error } = await supabaseClient
    .from("reminders")
    .insert([
      {
        ...reminderData,
        location, // Use the converted location
        user_id: userId,
        created_at: new Date().toISOString(),
      },
    ])
    .select()
    .single();

  return { data, error };
}

export async function deleteReminderById(reminderId: string, userId: string) {
  const { error } = await supabaseClient
    .from("reminders")
    .delete()
    .eq("id", reminderId)
    .eq("user_id", userId);

  return { error };
}
