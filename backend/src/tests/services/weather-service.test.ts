import { expect, jest, test } from "@jest/globals";
import {
  fetchCurrentWeatherInfo,
  fetchHourlyWeatherInfo,
} from "../../services/weather-service";
import config from "../../config/config";

// London coordinates
const location = {
  lat: 51.5049,
  lon: 0.126,
};

test("Check Openweather API key", () => {
  expect(config.openweatherKey).toBeDefined();
  expect(config.openweatherKey).not.toBe("");
});

test("Check current weather in London", async () => {
  const { data, error } = await fetchCurrentWeatherInfo(location);
  expect(error).toBeNull();
  expect(data?.coord.lat).toBe(location.lat);
  expect(data?.coord.lon).toBe(location.lon);
  expect(data?.sys.country).toBe("GB");
  expect(data?.weather[0]).toBeDefined();
});

// Weather forecast not included in the free tier
// test("Check weather forecast in London", async () => {
//   const { data, error } = await fetchHourlyWeatherInfo(location);
//   expect(error).toBeNull();
//   console.log(data);
// });
