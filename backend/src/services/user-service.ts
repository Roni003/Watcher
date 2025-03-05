import { IUser } from "../interfaces/user-interface";
import supabaseClient from "./supabase";

export async function getUserById(
  id: string
): Promise<{ data: IUser; error: any }> {
  const { data, error } = await supabaseClient
    .from("users")
    .select("*")
    .eq("id", id)
    .single();

  return { data, error };
}

export async function patchUserById(
  id: string,
  update: { radius: number; fetch_interval: number }
) {
  const { data, error } = await supabaseClient
    .from("users")
    .update(update)
    .eq("id", id)
    .select("*")
    .single();

  return { data, error };
}
