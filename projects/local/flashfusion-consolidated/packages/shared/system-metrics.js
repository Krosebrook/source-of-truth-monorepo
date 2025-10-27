const os = require('os');
const fs = require('fs');
const path = require('path');

class SystemMetrics {
  constructor() {
    this.metrics = [];
    this.logFile = path.join(__dirname, 'system-metrics.log');
  }

  getCPUUsage() {
    const cpus = os.cpus();
    let totalIdle = 0;
    let totalTick = 0;

    cpus.forEach(cpu => {
      for (const type in cpu.times) {
        totalTick += cpu.times[type];
      }
      totalIdle += cpu.times.idle;
    });

    const idle = totalIdle / cpus.length;
    const total = totalTick / cpus.length;
    const usage = 100 - ~~(100 * idle / total);
    
    return {
      usage: usage,
      cores: cpus.length,
      model: cpus[0].model
    };
  }

  getMemoryUsage() {
    const totalMem = os.totalmem();
    const freeMem = os.freemem();
    const usedMem = totalMem - freeMem;
    
    return {
      total: Math.round(totalMem / 1024 / 1024), // MB
      used: Math.round(usedMem / 1024 / 1024), // MB
      free: Math.round(freeMem / 1024 / 1024), // MB
      usagePercent: Math.round((usedMem / totalMem) * 100)
    };
  }

  getDiskUsage() {
    // Simple disk usage for current drive
    const stats = fs.statfsSync(process.cwd());
    const total = stats.blocks * stats.bsize;
    const free = stats.bavail * stats.bsize;
    const used = total - free;
    
    return {
      total: Math.round(total / 1024 / 1024 / 1024), // GB
      used: Math.round(used / 1024 / 1024 / 1024), // GB
      free: Math.round(free / 1024 / 1024 / 1024), // GB
      usagePercent: Math.round((used / total) * 100)
    };
  }

  getNetworkInfo() {
    const interfaces = os.networkInterfaces();
    const result = [];
    
    for (const name in interfaces) {
      for (const net of interfaces[name]) {
        if (net.family === 'IPv4' && !net.internal) {
          result.push({
            interface: name,
            address: net.address,
            netmask: net.netmask
          });
        }
      }
    }
    
    return result;
  }

  collectMetrics() {
    const metrics = {
      timestamp: new Date().toISOString(),
      hostname: os.hostname(),
      platform: os.platform(),
      uptime: Math.round(os.uptime()),
      cpu: this.getCPUUsage(),
      memory: this.getMemoryUsage(),
      disk: this.getDiskUsage(),
      network: this.getNetworkInfo(),
      loadAverage: os.loadavg()
    };

    this.metrics.push(metrics);
    this.logMetrics(metrics);
    
    return metrics;
  }

  logMetrics(metrics) {
    const logEntry = JSON.stringify(metrics) + '\n';
    fs.appendFileSync(this.logFile, logEntry);
  }

  printMetrics(metrics) {
    console.log('\n📊 System Metrics Report');
    console.log('========================');
    console.log(`🖥️  Hostname: ${metrics.hostname}`);
    console.log(`⏱️  Uptime: ${Math.floor(metrics.uptime / 3600)}h ${Math.floor((metrics.uptime % 3600) / 60)}m`);
    console.log(`\n💻 CPU:`);
    console.log(`   Model: ${metrics.cpu.model}`);
    console.log(`   Cores: ${metrics.cpu.cores}`);
    console.log(`   Usage: ${metrics.cpu.usage}%`);
    console.log(`\n💾 Memory:`);
    console.log(`   Total: ${metrics.memory.total} MB`);
    console.log(`   Used: ${metrics.memory.used} MB (${metrics.memory.usagePercent}%)`);
    console.log(`   Free: ${metrics.memory.free} MB`);
    console.log(`\n💿 Disk:`);
    console.log(`   Total: ${metrics.disk.total} GB`);
    console.log(`   Used: ${metrics.disk.used} GB (${metrics.disk.usagePercent}%)`);
    console.log(`   Free: ${metrics.disk.free} GB`);
    console.log(`\n🌐 Network:`);
    metrics.network.forEach(net => {
      console.log(`   ${net.interface}: ${net.address}`);
    });
    console.log('========================\n');
  }

  startMonitoring(interval = 60000) {
    console.log('🚀 Starting system metrics monitoring...\n');
    
    // Collect initial metrics
    const initialMetrics = this.collectMetrics();
    this.printMetrics(initialMetrics);
    
    // Schedule periodic collection
    setInterval(() => {
      const metrics = this.collectMetrics();
      this.printMetrics(metrics);
      
      // Alert on high usage
      if (metrics.cpu.usage > 80) {
        console.log('⚠️  WARNING: High CPU usage detected!');
      }
      if (metrics.memory.usagePercent > 90) {
        console.log('⚠️  WARNING: High memory usage detected!');
      }
      if (metrics.disk.usagePercent > 90) {
        console.log('⚠️  WARNING: Low disk space!');
      }
    }, interval);
  }
}

// Start monitoring if run directly
if (require.main === module) {
  const monitor = new SystemMetrics();
  monitor.startMonitoring(30000); // Check every 30 seconds
  
  // Handle graceful shutdown
  process.on('SIGINT', () => {
    console.log('\n\n👋 Stopping system monitoring...');
    process.exit(0);
  });
}

module.exports = SystemMetrics;