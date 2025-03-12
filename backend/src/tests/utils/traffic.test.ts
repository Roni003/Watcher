import { expect, test } from "@jest/globals";
import { aggregateTrafficData, interpretJamFactor } from "../../utils/traffic";
import { ITrafficResponse } from "../../interfaces/requests/traffic-response-interface";

test("Check low jam factor", () => {
  const jamFactor = 1.2;
  expect(interpretJamFactor(jamFactor)).toBe("Little to no traffic");
});

test("Check max jam factor", () => {
  const jamFactor = 10;
  expect(interpretJamFactor(jamFactor)).toBe("Standstill traffic");
});

test("Test data aggregation", () => {
  const mockResponse: ITrafficResponse = {
    sourceUpdated: "2021-09-01T12:00:00Z",
    results: [
      {
        location: {
          description: "a",
          length: 100,
        },
        currentFlow: {
          freeFlow: 100,
          jamFactor: 1,
          speed: 10,
          confidence: 0.8,
        },
      },
      {
        location: {
          description: "b",
          length: 50,
        },
        currentFlow: {
          freeFlow: 100,
          jamFactor: 6,
          speed: 25,
          confidence: 0.9,
        },
      },
    ],
  };

  const { averageJamFactor, averageConfidence, averageSpeed } =
    aggregateTrafficData(mockResponse);

  expect(averageJamFactor).toBeCloseTo(2.67, 0.05);
  expect(averageConfidence).toBeCloseTo(0.83);
  expect(averageSpeed).toBe(15);
});
