import { IReminder, ReminderMetadata } from "../interfaces/reminder-interface";
import { TriggerType } from "../interfaces/trigger-interface";
import supabaseClient from "./supabase";

export async function getRemindersForUser(userId: string): Promise<{
  data: IReminder[] | null;
  error: Error | null;
}> {
  const { data, error } = await supabaseClient
    .from("reminders")
    .select("*")
    .eq("user_id", userId);

  return { data, error };
}

export async function getRemindersById(
  reminderId: string,
  userId: string
): Promise<{ data: IReminder[] | null; error: Error | null }> {
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
  // Validate metadata based on trigger type
  // TODO: Refactor this to use a more generic approach
  if (reminderData.trigger) {
    console.log("Metadata: ", reminderData.metadata);
    // if (
    // reminderData.trigger === TriggerType.CUSTOMLOCATION &&
    // (!reminderData.metadata || !("location" in reminderData.metadata))
    // ) {
    // return {
    // error: new Error("Invalid metadata for CUSTOMLOCATION trigger"),
    // };
    // }
    if (
      reminderData.trigger === TriggerType.TFL &&
      (!reminderData.metadata || !("line" in reminderData.metadata))
    ) {
      return {
        error: new Error("Invalid metadata for TFL trigger"),
      };
    }
  }

  const { data, error } = await supabaseClient
    .from("reminders")
    .insert([
      {
        ...reminderData,
        user_id: userId,
        created_at: new Date().toISOString(),
      },
    ])
    .select()
    .single();

  if (error) {
    return { error };
  }

  return { data, error };
}

export async function patchReminderById(
  reminderId: string,
  userId: string,
  newData: Omit<IReminder, "id" | "created_at" | "user_id">
) {
  const { data, error } = await supabaseClient
    .from("reminders")
    .update({
      ...newData,
    })
    .eq("id", reminderId)
    .eq("user_id", userId)
    .select();

  if (error) {
    return { error };
  }

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
