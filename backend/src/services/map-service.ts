import config from "../config/config";
import { ILocation } from "../interfaces/location-interface";
import {
  IGooglePlace,
  IGooglePlacesResponse,
} from "../interfaces/requests/google-places-response-interface";

export async function getNearbyPlaces(
  location: ILocation,
  radius: number,
  locationTypes: string[],
  maxResultCount: number
): Promise<IGooglePlacesResponse> {
  const fieldMask = "places.displayName,places.googleMapsUri";
  const url = `https://places.googleapis.com/v1/places:searchNearby`;
  const body = {
    includedTypes: locationTypes,
    maxResultCount,
    locationRestriction: {
      circle: {
        center: {
          latitude: location.lat,
          longitude: location.lon,
        },
        radius,
      },
    },
  };

  const res = await fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-Goog-Api-Key": config.googleMapsKey,
      "X-Goog-FieldMask": fieldMask,
    },
    body: JSON.stringify(body),
  });

  const json: IGooglePlacesResponse = await res.json();

  return json;
}
