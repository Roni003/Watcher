export interface ITFLData {
  id?: string;
  name?: string;
  modeName?: string;
  disruptions?: IDisruption[];
  lineStatuses?: ILineStatus[];
}

export interface IDisruption {
  description?: string;
  summary?: string;
}

export interface ILineStatus {
  lineId?: string;
  statusSeverity?: number;
  statusSeverityDescription?: string;
  reason?: string;
}
