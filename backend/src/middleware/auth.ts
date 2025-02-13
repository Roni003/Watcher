import { Request, Response, NextFunction } from "express";
import { getUserFromToken } from "../utils/supabase/supabase-utils";

export async function authMiddleware(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const authToken = req.headers["ar-auth-token"] as string;
  if (!authToken) {
    console.log("Unauthorized, missing ar-auth-token header");
    res.status(401).send("Unauthorized, missing ar-auth-token header");
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
    console.error("[Error verifying ar-auth-token] " + error);
    res
      .status(401)
      .send("Unauthorized, invalid ar-auth-token - failed validateAuthToken");
  }
}
