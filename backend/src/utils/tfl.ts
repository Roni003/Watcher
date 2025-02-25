import { ITFLData } from "../interfaces/requests/tfl-response-interface";

export function doesLineHaveGoodService(tflData: ITFLData): boolean {
  if (!tflData.lineStatuses) {
    return false;
  }

  for (const lineStatus of tflData.lineStatuses) {
    if (lineStatus.statusSeverity !== 10) {
      return false;
    }
  }

  return true;
}
