import express, { Request, Response } from "express";
import morgan from "morgan";

import config from "./config/config";
import reminderRoutes from "./routes/reminders";

const app: express.Application = express();

const port: number = config.port;

app.listen(port, () => {
  console.log(`Listening at http://localhost:${port}`);
});

// ### Middleware ###

// Parse JSON bodies, Might need one later for cookies
app.use(morgan(config.environment === "dev" ? "dev" : "combined"));
app.use(express.json());

// ### Routes ###
app.use("/api/reminders", reminderRoutes);

app.use((req: Request, res: Response) => {
  res.status(404).send("Route not found");
  console.log("Route not found: " + req.url);
});
