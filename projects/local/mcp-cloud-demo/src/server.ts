import { FastMCP } from "fastmcp";
import { z } from "zod";
import * as dotenv from "dotenv";

dotenv.config();

// Environment configuration
const PORT = parseInt(process.env.PORT || "3000", 10);
const HOST = process.env.HOST || "0.0.0.0";
const NODE_ENV = process.env.NODE_ENV || "development";

// Create FastMCP server
const server = new FastMCP({
  name: "Cloud MCP Server",
  version: "1.0.0",
});

// Health check tool (required for K8s probes)
server.addTool({
  name: "health_check",
  description: "Check server health status",
  parameters: z.object({}),
  execute: async () => {
    return JSON.stringify({
      status: "healthy",
      timestamp: new Date().toISOString(),
      environment: NODE_ENV,
      uptime: process.uptime(),
    }, null, 2);
  },
});

// Example: Echo tool
server.addTool({
  name: "echo",
  description: "Echo back the input message",
  parameters: z.object({
    message: z.string().describe("Message to echo back"),
  }),
  execute: async ({ message }) => {
    console.log(`[TRACE] Echo tool called with message: ${message}`);
    return JSON.stringify({
      echo: message,
      timestamp: new Date().toISOString(),
    }, null, 2);
  },
});

// Example: Get time tool
server.addTool({
  name: "get_time",
  description: "Get current server time",
  parameters: z.object({
    timezone: z.string().optional().describe("Timezone (default: UTC)"),
  }),
  execute: async ({ timezone = "UTC" }) => {
    return JSON.stringify({
      time: new Date().toISOString(),
      timezone,
      unix_timestamp: Date.now(),
    }, null, 2);
  },
});

// Example resource
server.addResourceTemplate({
  uriTemplate: "server://info",
  name: "Server Information",
  mimeType: "application/json",
  arguments: [],
  async load() {
    return {
      text: JSON.stringify({
        name: "Cloud MCP Server",
        version: "1.0.0",
        environment: NODE_ENV,
        node_version: process.version,
        platform: process.platform,
      }, null, 2),
    };
  },
});

// Graceful shutdown
const shutdown = () => {
  console.log("\n[INFO] Shutting down gracefully...");
  process.exit(0);
};

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);

// Start server with SSE transport
async function main() {
  try {
    server.start({
      transportType: "sse",
      sse: {
        port: PORT,
        endpoint: "/sse",
      },
    });

    console.log(`[INFO] MCP Cloud Server running`);
    console.log(`[INFO] Environment: ${NODE_ENV}`);
    console.log(`[INFO] SSE endpoint: http://${HOST}:${PORT}/sse`);
    console.log(`[INFO] Ready to accept connections`);
  } catch (error) {
    console.error("[ERROR] Failed to start server:", error);
    process.exit(1);
  }
}

main();
