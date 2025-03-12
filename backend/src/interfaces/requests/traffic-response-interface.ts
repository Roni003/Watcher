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
  traversability?: ITraversability;
  subSegments?: {}[];
}

export enum ITraversability {
  OPEN = "open", // Road is open
  CLOSED = "closed", // Road is closed
  REVERSIBLENOTROUTABLE = "reversibleNotRoutable", // Road is reversible but not routable
}
