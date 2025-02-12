import { Request, Response, NextFunction } from "express";

export function validateAuthToken(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const authToken = req.headers["ar-auth-token"];
  if (!authToken) {
    res.status(401).send("Unauthorized, missing ar-auth-token header");
    return;
  }

  //   console.log("Auth token: " + authToken);
  next();
}
