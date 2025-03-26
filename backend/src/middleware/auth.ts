import { Request, Response, NextFunction } from "express";
import { getUserFromToken } from "../utils/supabase/supabase-utils";

const AUTH_TOKEN_HEADER_KEY = "watcher-auth-token";

export async function authMiddleware(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const authToken = req.headers[AUTH_TOKEN_HEADER_KEY] as string;
  if (!authToken) {
    console.log(`Unauthorized, missing ${AUTH_TOKEN_HEADER_KEY} header`);
    res
      .status(401)
      .send(`Unauthorized, missing ${AUTH_TOKEN_HEADER_KEY} header`);
    return;
  }

  try {
    const user = await getUserFromToken(authToken);
    // User exists if theres no error
    req.user = {
      id: user.id,
    };
    next();
  } catch (error) {
    console.error(error);
    res
      .status(401)
      .send(`Unauthorized, missing ${AUTH_TOKEN_HEADER_KEY} header`);
  }
}
