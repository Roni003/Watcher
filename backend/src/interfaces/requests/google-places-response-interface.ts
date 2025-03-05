export interface IGooglePlacesResponse {
  places: IGooglePlace[];
}

export interface IGooglePlace {
  displayName: IPlaceDisplayName;
  googleMapsUri: string;
}

export interface IPlaceDisplayName {
  text: string;
  languageCode: string;
}
