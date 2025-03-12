import config from "../config/config";
import { ILocation } from "../interfaces/location-interface";
import { ITrafficResponse } from "../interfaces/requests/traffic-response-interface";

export async function fetchTrafficData(location: ILocation, radius: number) {
  const HERE_API_KEY = config.hereKey;
  const url = `https://data.traffic.hereapi.com/v7/flow?locationReferencing=shape&in=circle:${location.lat},${location.lon};r=200&apiKey=${HERE_API_KEY}`;

  try {
    const response = await fetch(url);
    const data: ITrafficResponse = await response.json();
    return { data, error: null };
  } catch (error) {
    return { data: null, error };
  }
}
