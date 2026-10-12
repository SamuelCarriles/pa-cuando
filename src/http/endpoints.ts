import type { RequestHandler, Express } from "express";

type HttpMethod = "get" | "post" | "put" | "delete";

export type Endpoint = {
  method: HttpMethod;
  path: string;
  handlers: RequestHandler[];
};

function addEndpoint(app: Express, { method, path, handlers }: Endpoint): void {
  app[method](path, ...handlers);
}

export function addEndpoints(app: Express, endpoints: Endpoint[]): void {
  endpoints.forEach((endpoint) => addEndpoint(app, endpoint));
}
