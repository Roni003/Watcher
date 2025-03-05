import { expect, jest, test } from "@jest/globals";
import config from "../../config/config";

const location = {
  lat: 37.7749,
  lon: -122.4194,
};

test("Check Google Maps key", () => {
  expect(config.googleMapsKey).toBeDefined();
  expect(config.googleMapsKey).not.toBe("");
});
