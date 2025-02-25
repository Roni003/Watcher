export interface ITFLData {
  id?: string;
  name?: string;
  modeName?: string;
  disruptions?: IDisruption[];
}

export interface IDisruption {
  description?: string;
  summary?: string;
}
