import { ILocation } from "../interfaces/location-interface";

export async function getNearbyLocations(
  location: ILocation,
  options: {
    radius: number;
    groceryStores?: boolean;
    drugStores?: boolean;
  }
): Promise<any[]> {
  return [];
}
