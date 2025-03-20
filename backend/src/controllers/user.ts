import { Request, Response } from "express";
import { getUserById, patchUserById } from "../services/user-service";

export async function getUser(req: Request, res: Response) {
  const { data, error } = await getUserById(req.user.id);

  if (error) {
    console.error("[Error getting user]", error);
    res.status(400).json({
      error: error.message,
    });
    return;
  }

  res.json(data);
}

export async function patchUser(req: Request, res: Response) {
  const { radius, fetch_interval, battery_saver_mode } = req.body;

  const update = {
    radius,
    fetch_interval,
    battery_saver_mode,
  };

  const { data, error } = await patchUserById(req.user.id, update);

  if (error) {
    console.error("[Error updating user]", error);
    res.status(400).json({
      error: error.message,
    });
    return;
  }

  res.json(data);
}
