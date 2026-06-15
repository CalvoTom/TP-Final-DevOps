const express = require("express");
const db = require("../db");

const router = express.Router();

router.get("/", async (req, res) => {
  try {
    await db.query("SELECT 1");
    res.status(200).json({ ready: true });
  } catch (_err) {
    res.status(503).json({ ready: false, reason: "database unavailable" });
  }
});

module.exports = router;
