import { expect, test } from "@jest/globals";
import { interpretJamFactor } from "../../utils/traffic";

test("Check low jam factor", () => {
  const jamFactor = 1.2;
  expect(interpretJamFactor(jamFactor)).toBe("Little to no traffic");
});

test("Check max jam factor", () => {
  const jamFactor = 10;
  expect(interpretJamFactor(jamFactor)).toBe("Standstill traffic");
});
