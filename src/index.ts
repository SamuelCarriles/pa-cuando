import { startServer } from "./server.js";
import { createApp } from "./app.js";
import { loadAppConfig } from "./config/load.js";

const serverConfig = loadAppConfig().server;
const app = createApp();
startServer(app, serverConfig);
