export function interpretJamFactor(jamFactor: number): string {
  if (jamFactor < 2) {
    return "Little to no traffic";
  } else if (jamFactor < 3.5) {
    return "Little traffic";
  } else if (jamFactor < 5) {
    return "Moderate traffic";
  } else if (jamFactor < 7.5) {
    return "Heavy traffic";
  } else if (jamFactor < 9.5) {
    return "Very heavy traffic";
  } else {
    return "Standstill traffic";
  }
}

export function interpretConfidence(confidence: number): string {
  if (confidence <= 0.5) {
    return "Based on speed limit";
  } else if (confidence <= 0.7) {
    return "Based on historical speeds";
  } else {
    return "Based on real-time data";
  }
}
