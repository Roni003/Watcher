import { expect, jest, test } from "@jest/globals";
import { getNearbyLocations } from "../../utils/maps";
import { fetchWeatherInfo } from "../../services/weather-service";

const location = {
  lat: 37.7749,
  lon: -122.4194,
};

test("Check weather", async () => {
  const res = await fetchWeatherInfo(location);
  console.log(res);
});
