#!/usr/bin/env node

// Simple startup script for FlashFusion deployment
const { spawn } = require("child_process");
const path = require("path");

// Start the modern TypeScript server
const server = spawn("tsx", ["server/index.ts"], {
  stdio: "inherit",
  cwd: process.cwd(),
  env: { ...process.env, NODE_ENV: "production" },
});

server.on("error", (err) => {
  console.error("Failed to start server:", err);
  process.exit(1);
});

server.on("close", (code) => {
  console.log(`Server process exited with code ${code}`);
  if (code !== 0) {
    process.exit(code);
  }
});

// Handle graceful shutdown
process.on("SIGTERM", () => {
  console.log("Received SIGTERM, shutting down gracefully...");
  server.kill("SIGTERM");
});

process.on("SIGINT", () => {
  console.log("Received SIGINT, shutting down gracefully...");
  server.kill("SIGINT");
});

console.log("🚀 Starting FlashFusion server...");
