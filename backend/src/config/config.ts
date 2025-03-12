import "dotenv/config";
interface Config {
  TRIGGER_CHECK_MIN_INTERVAL_MS: number;
  TRAFFIC_JAM_FACTOR_TRIGGER_THRESHOLD: number;
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
  environment: process.env.ENVIRONMENT as "dev" | "prod",
  TRIGGER_CHECK_MIN_INTERVAL_MS:
    process.env.ENVIRONMENT == "dev" ? 1000 * 1 : 1000 * 150, // Don't let users spam triggercheck endpoint
  TRAFFIC_JAM_FACTOR_TRIGGER_THRESHOLD: 5.5, // Jam factor above this triggers traffic reminder
  port: process.env.PORT ? parseInt(process.env.PORT) : 3000,
  supabaseKey: process.env.SUPABASE_KEY || "",
  supabaseURL: process.env.SUPABASE_URL || "",
  openweatherKey: process.env.OPENWEATHER_KEY || "",
  tflKey: process.env.TFL_KEY || "",
  googleMapsKey: process.env.GOOGLE_MAPS_KEY || "",
  hereKey: process.env.HERE_KEY || "",
};

export default config;
