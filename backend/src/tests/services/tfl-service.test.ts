import { expect, jest, test } from "@jest/globals";
import { fetchTFLInfo } from "../../services/tfl-service";
import config from "../../config/config";

test("Check TFL API key", () => {
  expect(config.tflKey).toBeDefined();
  expect(config.tflKey).not.toBe("");
});

test("Check circle line service", async () => {
  const { data, error } = await fetchTFLInfo("circle");
  expect(error).toBeNull();
  expect(data?.id).toBe("circle");
  expect(data?.disruptions).toBeDefined();
});

test("Check district line service", async () => {
  const { data, error } = await fetchTFLInfo("district");
  expect(error).toBeNull();
  expect(data?.id).toBe("district");
  expect(data?.disruptions).toBeDefined();
});
