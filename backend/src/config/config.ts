import "dotenv/config";
interface Config {
  TRIGGER_CHECK_MIN_INTERVAL_MS: number;
  port: number;
  environment: "dev" | "prod";
  supabaseKey: string;
  supabaseURL: string;
  openweatherKey: string;
  tflKey: string;
  googleMapsKey: string;
  hereKey: string;
}

const config: Config = {
  TRIGGER_CHECK_MIN_INTERVAL_MS: 1000 * 30, // Don't let users spam triggercheck endpoint
  port: process.env.PORT ? parseInt(process.env.PORT) : 3000,
  environment: "dev",
  supabaseKey: process.env.SUPABASE_KEY || "",
  supabaseURL: process.env.SUPABASE_URL || "",
  openweatherKey: process.env.OPENWEATHER_KEY || "",
  tflKey: process.env.TFL_KEY || "",
  googleMapsKey: process.env.GOOGLE_MAPS_KEY || "",
  hereKey: process.env.HERE_KEY || "",
};

export default config;
