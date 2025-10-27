/**
 * Structured JSON logger for FlashFusion SoT monorepo
 * Provides consistent logging across all projects with OTEL compatibility
 */

export type LogLevel = "debug" | "info" | "warn" | "error" | "fatal";

export interface LogEntry {
  ts: string;
  level: LogLevel;
  msg: string;
  trace_id?: string;
  workflow_id?: string;
  span_id?: string;
  [key: string]: any;
}

export class JsonLogger {
  constructor(private readonly service: string) {}

  private log(level: LogLevel, msg: string, meta: Record<string, any> = {}): void {
    const entry: LogEntry = {
      ts: new Date().toISOString(),
      level,
      msg,
      service: this.service,
      ...meta,
    };

    // Inject trace context if available (OTEL compatible)
    if (process.env.TRACE_ID) {
      entry.trace_id = process.env.TRACE_ID;
    }
    if (process.env.WORKFLOW_ID) {
      entry.workflow_id = process.env.WORKFLOW_ID;
    }
    if (process.env.SPAN_ID) {
      entry.span_id = process.env.SPAN_ID;
    }

    // Write to stdout (JSON format)
    console.log(JSON.stringify(entry));
  }

  debug(msg: string, meta?: Record<string, any>): void {
    this.log("debug", msg, meta);
  }

  info(msg: string, meta?: Record<string, any>): void {
    this.log("info", msg, meta);
  }

  warn(msg: string, meta?: Record<string, any>): void {
    this.log("warn", msg, meta);
  }

  error(msg: string, meta?: Record<string, any>): void {
    this.log("error", msg, meta);
  }

  fatal(msg: string, meta?: Record<string, any>): void {
    this.log("fatal", msg, meta);
    process.exit(1);
  }
}

// Default export for convenience
export const createLogger = (service: string): JsonLogger => {
  return new JsonLogger(service);
};

// Global logger instance (can be overridden)
export const log = createLogger("flashfusion-sot");
