require("dotenv").config();
const express = require("express");
const routes = require("./routes");
const { requestLogger } = require("./middleware/logger");

const app = express();
app.use(express.json());
app.use(requestLogger);

// Health check — does NOT require API key (used by load balancers / uptime monitors)
app.get("/health", (_, res) => res.json({ status: "ok" }));

app.use("/", routes);

// Global error handler
app.use((err, req, res, _next) => {
  console.error(err);
  res.status(500).json({ error: "Internal server error" });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Reward API running on port ${PORT}`);
  console.log(`RPC:      ${process.env.RPC_URL}`);
  console.log(`Contract: ${require("./blockchain/contract.json").address}`);
});
