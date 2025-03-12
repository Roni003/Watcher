export interface ITrafficResponse {
  sourceUpdated: string;
  results: Array<IResult>;
}

interface IResult {
  location: ITrafficLocation;
  currentFlow: ITrafficFlow;
}

interface ITrafficLocation {
  description?: string;
  length: number;
  shape?: {};
}

interface ITrafficFlow {
  freeFlow: number;
  jamFactor: number;
  speed?: number;
  speedUncapped?: number;
  confidence?: number;
  traversability?: string;
  subSegments?: {}[];
}
