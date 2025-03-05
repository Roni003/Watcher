import { Router, Request, Response } from "express";
import {
  getReminders,
  deleteReminder,
  createReminder,
  checkReminderTriggers,
  patchReminder,
} from "../controllers/reminders";

const router: Router = Router();

// Get all reminders
router.get("/", getReminders);

// Create new reminder
router.post("/", createReminder);

// Delete reminder
router.delete("/:id", deleteReminder);

// Update reminder
router.patch("/:id", patchReminder);

// Check if reminders should be triggered
router.post("/triggercheck", checkReminderTriggers);

export default router;
