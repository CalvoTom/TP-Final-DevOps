const { URL } = require("url");

const LEVELS = { debug: 0, info: 1, warn: 2, error: 3 };
const SENSITIVE_PARAMS = ["token", "key", "password", "secret", "api_key"];

function sanitizePath(url) {
  const parsed = new URL(url, "http://localhost");
  SENSITIVE_PARAMS.forEach((p) => {
    if (parsed.searchParams.has(p)) parsed.searchParams.set(p, "[REDACTED]");
  });
  return parsed.pathname + parsed.search;
}

function log(level, data) {
  const minLevel = LEVELS[process.env.LOG_LEVEL] ?? LEVELS.info;
  if (LEVELS[level] >= minLevel) {
    console.log(JSON.stringify({ level, ...data }));
  }
}

function httpLogger(req, res, next) {
  const startedAt = Date.now();
  res.on("finish", () => {
    log("info", {
      method: req.method,
      path: sanitizePath(req.originalUrl),
      status: res.statusCode,
      duration_ms: Date.now() - startedAt,
      request_id: req.requestId,
      timestamp: new Date().toISOString()
    });
  });
  next();
}

module.exports = httpLogger;
module.exports.log = log;
