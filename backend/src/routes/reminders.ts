import { Router, Request, Response } from "express";

const router: Router = Router();

// Get all reminders
router.get("/", (req: Request, res: Response) => {
  res.send("Hello from reminders");
});

// Create new reminder
router.post("/", (req: Request, res: Response) => {});

// Delete reminder
router.delete("/:id", (req: Request, res: Response) => {});

// Update reminder
router.put("/:id", (req: Request, res: Response) => {});

// Check if reminders should be triggered
router.get("/triggercheck", (req: Request, res: Response) => {
  // Take location from request header or query string
  // Check if location is valid
  // Fetch all reminders from database
  // check proximity and trigger conditions
});

export default router;
