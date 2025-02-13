import { Request, Response, NextFunction } from "express";
import { IAuthenticatedRequest } from "../interfaces/authenticated-request-interface";
import { getUserFromToken } from "../utils/supabase/supabase-utils";

export async function authMiddleware(
  expressRequest: Request,
  res: Response,
  next: NextFunction
) {
  const req = expressRequest as IAuthenticatedRequest;
  const authToken = req.headers["ar-auth-token"] as string;
  if (!authToken) {
    res.status(401).send("Unauthorized, missing ar-auth-token header");
    return;
  }

  try {
    const user = await getUserFromToken(authToken);
    // User exists if theres no error
    req.user = {
      id: user.id,
    };
    // console.log("User: ", user);
    next();
  } catch (error) {
    console.error("[Error verifying ar-auth-token] " + error);
    res
      .status(401)
      .send("Unauthorized, invalid ar-auth-token - failed validateAuthToken");
  }
}
