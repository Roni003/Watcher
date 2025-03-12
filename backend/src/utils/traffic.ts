import { ITrafficResponse } from "../interfaces/requests/traffic-response-interface";

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

export function aggregateTrafficData(data: ITrafficResponse): {
  averageJamFactor: number;
  averageConfidence: number;
  averageSpeed: number;
} {
  const { results } = data;

  if (results.length === 0) {
    return { averageJamFactor: 0, averageConfidence: 0, averageSpeed: 0 };
  }

  let totalWeightedJamFactor = 0;
  let totalWeightedConfidence = 0;
  let totalWeightedSpeed = 0;
  let totalLength = 0;

  for (const result of results) {
    const len = result.location.length || 0;
    if (len === 0) continue; // Avoid division errors for zero-length segments

    totalLength += len;
    totalWeightedJamFactor += len * result.currentFlow.jamFactor;
    totalWeightedConfidence += len * (result.currentFlow.confidence ?? 0);
    totalWeightedSpeed += len * (result.currentFlow.speed ?? 0);
  }

  const averageJamFactor = totalWeightedJamFactor / totalLength;
  const averageConfidence = totalWeightedConfidence / totalLength;
  const averageSpeed = totalWeightedSpeed / totalLength;
  return {
    averageJamFactor,
    averageConfidence,
    averageSpeed,
  };
}
