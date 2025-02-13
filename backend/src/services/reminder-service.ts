// Make functions to get, set delete reminders etc from user ID and reminder id?

import supabaseClient from "./supabase";

// Call these in the controller.
export async function getRemindersForUser(userId: string) {
  const { data, error } = await supabaseClient
    .from("reminders")
    .select("*")
    .eq("user_id", userId);

  if (error) {
    throw new Error(error.message);
  }

  return data;
}
