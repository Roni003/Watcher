import { createClient } from "@supabase/supabase-js";
import config from "../config/config";

const supabaseClient = createClient(config.supabaseURL, config.supabaseKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
  },
});

export default supabaseClient;
