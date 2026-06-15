const express = require("express");
const cors = require("cors");
const requestId = require("./middleware/request-id");
const logger = require("./middleware/logger");
const healthRoutes = require("./routes/health");
const readyRoutes = require("./routes/ready");
const productRoutes = require("./routes/products");

const app = express();

app.use(cors());
app.use(express.json());
app.use(requestId);
app.use(logger);

app.get("/", (req, res) => {
  res.json({
    name: "ShopLite API",
    version: process.env.APP_VERSION || "0.1.0",
    endpoints: ["/health", "/ready", "/products"]
  });
});

app.use("/health", healthRoutes);
app.use("/ready", readyRoutes);
app.use("/products", productRoutes);

app.use((req, res) => {
  res.status(404).json({ error: "Route not found" });
});

app.use((err, req, res, next) => {
  logger.log("error", {
    message: err.message,
    request_id: req.requestId,
    timestamp: new Date().toISOString()
  });

  res.status(500).json({ error: "Internal server error" });
});

module.exports = app;
