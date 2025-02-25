const BAD_WEATHER_NAMES = ["rain", "storm", "snow", "thunder"];

export function isBadWeather(weather: string): boolean {
  for (const badWeatherName of BAD_WEATHER_NAMES) {
    if (weather.toLowerCase().includes(badWeatherName)) {
      return true;
    }
  }

  return false;
}
