import { expect, test } from "@jest/globals";
import { isBadWeather } from "../../utils/weather";

test("Check rainy weather is bad", () => {
  const weather = "Slight Rain";
  expect(isBadWeather(weather)).toBe(true);
});

test("Check snowy weather is bad", () => {
  const weather = "Snowy";
  expect(isBadWeather(weather)).toBe(true);
});

test("Check weather is good", () => {
  const weather = "Clouds";
  expect(isBadWeather(weather)).toBe(false);
});
