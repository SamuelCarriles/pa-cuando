import { z } from "zod";

export const serverConfigSchema = z.object({
  port: z.coerce.number().int().min(1025).max(65535),
});

export type ServerConfig = z.infer<typeof serverConfigSchema>;

export type Config = {
  server: ServerConfig;
};
