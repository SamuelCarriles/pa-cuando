import express, { type Express } from "express";
import { healthCheckEndpoint } from "./health/routes.js";
import { addEndpoints, type Endpoint } from "./http/endpoints.js";

const endpoints: Endpoint[] = [healthCheckEndpoint];

export function createApp(): Express {
  const app = express();
  addEndpoints(app, endpoints);
  return app;
}
