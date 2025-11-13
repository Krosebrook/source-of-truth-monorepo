const http = require('http');
const https = require('https');
const fs = require('fs');
const path = require('path');

// Health check configuration
const config = {
  endpoints: [
    { name: 'Frontend', url: 'http://localhost:4200', method: 'GET' },
    { name: 'Backend API', url: 'http://localhost:3001/api/health', method: 'GET' },
    { name: 'Auth Service', url: 'http://localhost:3001/api/auth/status', method: 'GET' },
  ],
  checkInterval: 30000, // 30 seconds
  timeout: 5000, // 5 seconds timeout for each check
  logFile: path.join(__dirname, 'health-check.log'),
};

class HealthMonitor {
  constructor() {
    this.results = new Map();
    this.startTime = Date.now();
  }

  async checkEndpoint(endpoint) {
    return new Promise((resolve) => {
      const startTime = Date.now();
      const url = new URL(endpoint.url);
      const client = url.protocol === 'https:' ? https : http;

      const options = {
        hostname: url.hostname,
        port: url.port || (url.protocol === 'https:' ? 443 : 80),
        path: url.pathname + url.search,
        method: endpoint.method || 'GET',
        timeout: config.timeout,
      };

      const req = client.request(options, (res) => {
        const responseTime = Date.now() - startTime;
        const status = res.statusCode >= 200 && res.statusCode < 400 ? 'healthy' : 'unhealthy';

        resolve({
          name: endpoint.name,
          url: endpoint.url,
          status,
          statusCode: res.statusCode,
          responseTime,
          timestamp: new Date().toISOString(),
        });
      });

      req.on('error', (error) => {
        resolve({
          name: endpoint.name,
          url: endpoint.url,
          status: 'error',
          error: error.message,
          responseTime: Date.now() - startTime,
          timestamp: new Date().toISOString(),
        });
      });

      req.on('timeout', () => {
        req.destroy();
        resolve({
          name: endpoint.name,
          url: endpoint.url,
          status: 'timeout',
          error: 'Request timeout',
          responseTime: config.timeout,
          timestamp: new Date().toISOString(),
        });
      });

      req.end();
    });
  }

  async runHealthChecks() {
    console.log(`[${new Date().toISOString()}] Running health checks...`);

    const promises = config.endpoints.map((endpoint) => this.checkEndpoint(endpoint));
    const results = await Promise.all(promises);

    results.forEach((result) => {
      this.results.set(result.name, result);
      this.logResult(result);
    });

    this.printSummary();
    return results;
  }

  logResult(result) {
    const logEntry = JSON.stringify(result) + '\n';
    fs.appendFileSync(config.logFile, logEntry);

    const statusIcon = result.status === 'healthy' ? '✅' : result.status === 'error' ? '❌' : '⚠️';

    console.log(`${statusIcon} ${result.name}: ${result.status} (${result.responseTime}ms)`);
  }

  printSummary() {
    const uptime = Math.floor((Date.now() - this.startTime) / 1000);
    const healthy = Array.from(this.results.values()).filter((r) => r.status === 'healthy').length;
    const total = this.results.size;

    console.log(`\n📊 Health Summary: ${healthy}/${total} services healthy`);
    console.log(`⏱️  Uptime: ${uptime}s\n`);
  }

  start() {
    console.log('🚀 Starting health monitoring...\n');

    // Run initial check
    this.runHealthChecks();

    // Schedule periodic checks
    setInterval(() => {
      this.runHealthChecks();
    }, config.checkInterval);
  }
}

// Start monitoring if run directly
if (require.main === module) {
  const monitor = new HealthMonitor();
  monitor.start();

  // Handle graceful shutdown
  process.on('SIGINT', () => {
    console.log('\n\n👋 Stopping health monitoring...');
    process.exit(0);
  });
}

module.exports = HealthMonitor;
