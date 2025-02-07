interface Config {
  port: number;
  environment: "dev" | "prod";
}

const config: Config = {
  port: 3000,
  environment: "dev",
};

export default config;
