import supabaseClient from "../../services/supabase";

/**
 * Returns user object from a JWT token
 * @param jwt
 * @returns user object
 */
export async function getUserFromToken(jwt: string) {
  try {
    const {
      data: { user },
      error,
    } = await supabaseClient.auth.getUser(jwt);

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
    };
  } catch (error: any) {
    console.error("Error getting user from token:", error.message);
    throw error;
  }
}
