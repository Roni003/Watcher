import { Request, Response, NextFunction } from "express";
import { IAuthenticatedRequest } from "../interfaces/authenticated-request-interface";
import supabaseClient from "../services/supabase";
import { getUserFromToken } from "../utils/supabase/supabase-utils";

export async function authMiddleware(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const authToken = req.headers["ar-auth-token"] as string;
  if (!authToken) {
    res.status(401).send("Unauthorized, missing ar-auth-token header");
    return;
  }

  try {
    const user = await getUserFromToken(authToken);
    // User exists if theres no error
    // req.user = {
    //   id: user.id,
    // };
    console.log("User: ", user);
    next();
  } catch (error) {
    console.error(error);
    res
      .status(401)
      .send("Unauthorized, invalid ar-auth-token failed validateAuthToken");
  }
}
