import "dotenv/config";
interface Config {
  port: number;
  environment: "dev" | "prod";
  supabaseKey: string;
  supabaseURL: string;
  openweatherKey: string;
  tflKey: string;
  googleMapsKey: string;
}

const config: Config = {
  port: process.env.PORT ? parseInt(process.env.PORT) : 3000,
  environment: "dev",
  supabaseKey: process.env.SUPABASE_KEY || "",
  supabaseURL: process.env.SUPABASE_URL || "",
  openweatherKey: process.env.OPENWEATHER_KEY || "",
  tflKey: process.env.TFL_KEY || "",
  googleMapsKey: process.env.GOOGLE_MAPS_KEY || "",
};

export default config;
