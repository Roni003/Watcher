import express, { Request, Response } from "express";
import morgan from "morgan";
import rateLimit from "express-rate-limit";

import config from "./config/config";
import reminderRoutes from "./routes/reminders";
import userRoutes from "./routes/user";
import { authMiddleware } from "./middleware/auth";

const app: express.Application = express();
const port: number = config.port;
const rateLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
});

app.listen(port, () => {
  console.log(`Running in mode: ${config.environment}`);
  console.log(`Listening at http://localhost:${port}`);
});

// ### Middleware ###

// Parse JSON bodies, Might need one later for cookies
app.use(morgan(config.environment === "dev" ? "dev" : "combined"));
app.use(express.json());
app.use(rateLimiter);

app.use(authMiddleware);

// ### Routes ###
app.use("/api/reminders", reminderRoutes);
app.use("/api/users", userRoutes);

app.use((req: Request, res: Response) => {
  res.status(404).send("Route not found");
  console.log("Route not found: " + req.url);
});
