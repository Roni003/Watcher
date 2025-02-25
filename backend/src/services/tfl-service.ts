import config from "../config/config";
import { ITFLData } from "../interfaces/requests/tfl-response-interface";

export async function fetchTFLInfo(
  line: string
): Promise<{ data?: ITFLData; error: any }> {
  const url = `https://api.tfl.gov.uk/Line/${line}/Status?app_key=${config.tflKey}`;
  try {
    const response = await fetch(url);
    const data = await response.json();
    const status: ITFLData = data[0];
    return { data: status, error: null };
  } catch (error) {
    return { error };
  }
}
