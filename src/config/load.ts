import {
  serverConfigSchema,
  type Config,
  type ServerConfig,
} from "./schema.js";

function loadServerConfig(): ServerConfig {
  return serverConfigSchema.parse({
    port: process.env.SERVER_PORT,
  });
}

export function loadAppConfig(): Config {
  return {
    server: loadServerConfig(),
  };
}
