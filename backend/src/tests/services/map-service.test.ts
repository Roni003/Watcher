import { expect, jest, test } from "@jest/globals";
import config from "../../config/config";
import { getNearbyPlaces } from "../../services/map-service";

const radius = 200;
const maxResults = 3;
const location = {
  lat: 51.52189460820863,
  lon: -0.07858038721018323,
};

test("Check Google Maps key", () => {
  expect(config.googleMapsKey).toBeDefined();
  expect(config.googleMapsKey).not.toBe("");
});

test("Check nearby supermarkets", async () => {
  const nearbySupermarkets = await getNearbyPlaces(
    location,
    radius,
    ["supermarket"],
    maxResults
  );

  expect(nearbySupermarkets).toBeDefined();
});
