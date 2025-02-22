import { Router, Request, Response } from "express";
import { getUser, patchUser } from "../controllers/user";

const router: Router = Router();

// Gets the user from the request object
router.get("/", getUser);

router.patch("/", patchUser);

export default router;
