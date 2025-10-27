const fs = require('fs');
const path = require('path');
const EventEmitter = require('events');

class AlertManager extends EventEmitter {
  constructor(config = {}) {
    super();
    
    this.config = {
      alertFile: path.join(__dirname, 'alerts.log'),
      maxAlerts: 100,
      alertThresholds: {
        cpu: 80,
        memory: 90,
        disk: 90,
        responseTime: 5000,
        errorRate: 0.1
      },
      ...config
    };
    
    this.alerts = [];
    this.alertCounts = new Map();
  }

  createAlert(severity, category, message, details = {}) {
    const alert = {
      id: Date.now().toString(36) + Math.random().toString(36).substr(2),
      timestamp: new Date().toISOString(),
      severity, // 'critical', 'warning', 'info'
      category, // 'system', 'application', 'security', 'performance'
      message,
      details,
      acknowledged: false
    };
    
    this.alerts.unshift(alert);
    
    // Keep only recent alerts
    if (this.alerts.length > this.config.maxAlerts) {
      this.alerts = this.alerts.slice(0, this.config.maxAlerts);
    }
    
    // Track alert frequency
    const key = `${category}:${severity}`;
    this.alertCounts.set(key, (this.alertCounts.get(key) || 0) + 1);
    
    // Log alert
    this.logAlert(alert);
    
    // Emit event
    this.emit('alert', alert);
    
    // Console output with color coding
    this.printAlert(alert);
    
    return alert;
  }

  logAlert(alert) {
    const logEntry = JSON.stringify(alert) + '\n';
    fs.appendFileSync(this.config.alertFile, logEntry);
  }

  printAlert(alert) {
    const icons = {
      critical: '🚨',
      warning: '⚠️',
      info: 'ℹ️'
    };
    
    const icon = icons[alert.severity] || '📌';
    console.log(`\n${icon} [${alert.severity.toUpperCase()}] ${alert.message}`);
    
    if (Object.keys(alert.details).length > 0) {
      console.log('   Details:', JSON.stringify(alert.details, null, 2));
    }
  }

  acknowledgeAlert(alertId) {
    const alert = this.alerts.find(a => a.id === alertId);
    if (alert) {
      alert.acknowledged = true;
      alert.acknowledgedAt = new Date().toISOString();
      return true;
    }
    return false;
  }

  getAlerts(filters = {}) {
    let filtered = [...this.alerts];
    
    if (filters.severity) {
      filtered = filtered.filter(a => a.severity === filters.severity);
    }
    
    if (filters.category) {
      filtered = filtered.filter(a => a.category === filters.category);
    }
    
    if (filters.unacknowledged) {
      filtered = filtered.filter(a => !a.acknowledged);
    }
    
    if (filters.limit) {
      filtered = filtered.slice(0, filters.limit);
    }
    
    return filtered;
  }

  checkThreshold(metric, value, threshold) {
    if (value > threshold) {
      const severity = value > threshold * 1.2 ? 'critical' : 'warning';
      this.createAlert(
        severity,
        'performance',
        `${metric} threshold exceeded`,
        {
          metric,
          value,
          threshold,
          exceededBy: value - threshold
        }
      );
      return true;
    }
    return false;
  }

  checkSystemMetrics(metrics) {
    const alerts = [];
    
    // CPU check
    if (metrics.cpu && this.checkThreshold('CPU Usage', metrics.cpu.usage, this.config.alertThresholds.cpu)) {
      alerts.push('cpu');
    }
    
    // Memory check
    if (metrics.memory && this.checkThreshold('Memory Usage', metrics.memory.usagePercent, this.config.alertThresholds.memory)) {
      alerts.push('memory');
    }
    
    // Disk check
    if (metrics.disk && this.checkThreshold('Disk Usage', metrics.disk.usagePercent, this.config.alertThresholds.disk)) {
      alerts.push('disk');
    }
    
    return alerts;
  }

  checkHealthStatus(healthResults) {
    const unhealthy = healthResults.filter(r => r.status !== 'healthy');
    
    if (unhealthy.length > 0) {
      unhealthy.forEach(service => {
        const severity = service.status === 'error' ? 'critical' : 'warning';
        this.createAlert(
          severity,
          'application',
          `Service ${service.name} is ${service.status}`,
          {
            service: service.name,
            url: service.url,
            error: service.error,
            responseTime: service.responseTime
          }
        );
      });
    }
    
    // Check response times
    healthResults.forEach(service => {
      if (service.responseTime > this.config.alertThresholds.responseTime) {
        this.createAlert(
          'warning',
          'performance',
          `Slow response from ${service.name}`,
          {
            service: service.name,
            responseTime: service.responseTime,
            threshold: this.config.alertThresholds.responseTime
          }
        );
      }
    });
  }

  getSummary() {
    const summary = {
      total: this.alerts.length,
      unacknowledged: this.alerts.filter(a => !a.acknowledged).length,
      bySeverity: {
        critical: this.alerts.filter(a => a.severity === 'critical').length,
        warning: this.alerts.filter(a => a.severity === 'warning').length,
        info: this.alerts.filter(a => a.severity === 'info').length
      },
      byCategory: {
        system: this.alerts.filter(a => a.category === 'system').length,
        application: this.alerts.filter(a => a.category === 'application').length,
        security: this.alerts.filter(a => a.category === 'security').length,
        performance: this.alerts.filter(a => a.category === 'performance').length
      },
      recentAlerts: this.getAlerts({ limit: 5, unacknowledged: true })
    };
    
    return summary;
  }

  printSummary() {
    const summary = this.getSummary();
    
    console.log('\n📋 Alert Summary');
    console.log('================');
    console.log(`Total Alerts: ${summary.total} (${summary.unacknowledged} unacknowledged)`);
    console.log('\nBy Severity:');
    console.log(`  🚨 Critical: ${summary.bySeverity.critical}`);
    console.log(`  ⚠️  Warning: ${summary.bySeverity.warning}`);
    console.log(`  ℹ️  Info: ${summary.bySeverity.info}`);
    console.log('\nBy Category:');
    console.log(`  System: ${summary.byCategory.system}`);
    console.log(`  Application: ${summary.byCategory.application}`);
    console.log(`  Security: ${summary.byCategory.security}`);
    console.log(`  Performance: ${summary.byCategory.performance}`);
    
    if (summary.recentAlerts.length > 0) {
      console.log('\nRecent Unacknowledged Alerts:');
      summary.recentAlerts.forEach(alert => {
        console.log(`  - [${alert.severity}] ${alert.message}`);
      });
    }
    
    console.log('================\n');
  }
}

// Export for use in other modules
module.exports = AlertManager;

// Demo if run directly
if (require.main === module) {
  const alertManager = new AlertManager();
  
  // Listen for alerts
  alertManager.on('alert', (alert) => {
    console.log('New alert event received:', alert.id);
  });
  
  // Create some test alerts
  alertManager.createAlert('info', 'system', 'Monitoring system started');
  alertManager.createAlert('warning', 'performance', 'High CPU usage detected', { cpu: 85 });
  alertManager.createAlert('critical', 'application', 'Database connection failed', { error: 'Connection timeout' });
  
  // Print summary
  setTimeout(() => {
    alertManager.printSummary();
  }, 1000);
}