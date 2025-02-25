import config from "../config/config";
import { ILocation } from "../interfaces/location-interface";
// jest.setup.js
require("dotenv").config("../../../.env");

/**
 *
 * @param {ILocation} location - location to get weather info about
 * @returns {Promise} - fetch request that returns weather information
 */
export async function fetchWeatherInfo(
  location: ILocation
): Promise<{ data: any; error: any }> {
  const { lat, lon } = location;
  const OW_API_KEY = config.openweatherKey;
  const url = `https://api.openweathermap.org/data/2.5/weather?units=metric&lat=${lat}&lon=${lon}&appid=${OW_API_KEY}`;

  try {
    const res = await fetch(url);
    const data = await res.json();
    return { data, error: null };
  } catch (error) {
    return { data: null, error };
  }
}
