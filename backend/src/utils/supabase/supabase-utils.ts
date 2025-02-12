import supabaseClient from "../../services/supabase";
// Function to get user info from JWT session token
export async function getUserFromToken(sessionToken: string) {
  try {
    const {
      data: { user },
      error,
    } = await supabaseClient.auth.getUser(sessionToken);

    if (error) {
      throw error;
    }

    if (!user) {
      throw new Error("User not found");
    }

    return {
      id: user.id,
      email: user.email,
      metadata: user.user_metadata,
      created_at: user.created_at,
      // Add any other user properties you need
    };
  } catch (error: any) {
    console.error("Error getting user from token:", error.message);
    throw error;
  }
}
