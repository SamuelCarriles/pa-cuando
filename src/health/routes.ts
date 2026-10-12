import type { RequestHandler } from "express";
import type { Endpoint } from "../http/endpoints.js";

const healthHandler: RequestHandler = (_req, resp) => {
  resp.status(200).json({ status: "ok" });
};

export const healthCheckEndpoint: Endpoint = {
  method: "get",
  path: "/health",
  handlers: [healthHandler],
};
