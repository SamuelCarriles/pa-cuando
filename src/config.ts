import { z } from "zod";

const serverConfigSchema = z.object({
  port: z.coerce.number().int().min(1025).max(65535),
});

export type ServerConfig = z.infer<typeof serverConfigSchema>;

export type Config = {
  server: ServerConfig;
};

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
