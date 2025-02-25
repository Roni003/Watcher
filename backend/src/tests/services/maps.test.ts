import { expect, jest, test } from "@jest/globals";
import { getNearbyLocations } from "../../utils/maps";

const location = {
  lat: 37.7749,
  lon: -122.4194,
};

test("Get nearby stores and drugstores", () => {
  const options = {
    radius: 1000,
    groceryStores: true,
    drugStores: true,
  };
  return getNearbyLocations(location, options).then((locations) => {
    expect(locations).toEqual([]);
  });
});
