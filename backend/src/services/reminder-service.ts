// Make functions to get, set delete reminders etc from user ID and reminder id?

import supabaseClient from "./supabase";

// Call these in the controller.
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

export async function deleteReminderById(reminderId: string, userId: string) {
  const { error } = await supabaseClient
    .from("reminders")
    .delete()
    .eq("id", reminderId)
    .eq("user_id", userId);

  return { error };
}
