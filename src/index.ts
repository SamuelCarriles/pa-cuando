import { startServer } from "./server.js";
import app from "./app.js";
import { loadAppConfig } from "./config/config.js";

const serverConfig = loadAppConfig().server;

startServer(app, serverConfig);
