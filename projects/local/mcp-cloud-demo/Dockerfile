# Multi-stage build for production
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY tsconfig.json ./

# Install dependencies
RUN npm ci --only=production && \
    npm install --save-dev typescript tsx

# Copy source
COPY src ./src

# Build TypeScript
RUN npm run build

# Production stage
FROM node:20-alpine

# Security: Run as non-root user
RUN addgroup -g 1001 -S mcp && \
    adduser -S mcp -u 1001

WORKDIR /app

# Copy only production files
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/build ./build
COPY --from=builder /app/node_modules ./node_modules

# Set ownership
RUN chown -R mcp:mcp /app

# Switch to non-root user
USER mcp

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "fetch('http://localhost:3000/sse').then(r => r.ok ? process.exit(0) : process.exit(1))" || exit 1

# Start server
CMD ["node", "build/server.js"]
