import type { Express } from "express";
import type { ServerConfig } from "./config/schemas.js";

export function startServer(app: Express, { port }: ServerConfig): void {
  app.listen(port, () => {
    console.log(`Server listening on port ${port}`);
  });
}
