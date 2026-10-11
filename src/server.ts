import type { Express } from "express";
import type { ServerConfig } from "./config.js";

export function startServer(app: Express, config: ServerConfig): void {
  const port = config.port;
  app.listen(port, () => {
    console.log(`RefHub listening on port ${port}`);
  });
}
