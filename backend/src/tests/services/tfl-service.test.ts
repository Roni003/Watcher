import { expect, jest, test } from "@jest/globals";
import { fetchTFLInfo } from "../../services/tfl-service";

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
