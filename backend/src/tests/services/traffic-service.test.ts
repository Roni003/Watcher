import { expect, jest, test } from "@jest/globals";
import config from "../../config/config";
import { fetchTrafficData } from "../../services/traffic-service";

const radius = 200;
const location = {
  lat: 51.52189460820863,
  lon: -0.07858038721018323,
};

test("Check HERE API key", () => {
  expect(config.hereKey).toBeDefined();
  expect(config.hereKey).not.toBe("");
});

test("Check curent traffic", async () => {
  const { data, error } = await fetchTrafficData(location, radius);
  console.log(data);
  expect(data).toBeDefined();
  expect(error).toBeNull();

  expect(data?.sourceUpdated).toBeDefined();
  expect(data?.results).toBeDefined();
});
