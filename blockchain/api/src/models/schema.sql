-- Run once to set up the schema.
-- Execute: psql $DATABASE_URL -f src/models/schema.sql

CREATE TABLE IF NOT EXISTS users (
  id                   TEXT PRIMARY KEY,
  wallet_address       TEXT NOT NULL UNIQUE,
  encrypted_private_key TEXT NOT NULL,
  original_user_id      TEXT,
  is_active             BOOLEAN NOT NULL DEFAULT TRUE,
  deactivated_at        TIMESTAMPTZ,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE users ADD COLUMN IF NOT EXISTS original_user_id TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT TRUE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

CREATE TABLE IF NOT EXISTS reward_events (
  id               SERIAL PRIMARY KEY,
  reward_event_id  TEXT NOT NULL UNIQUE,   -- idempotency key
  user_id          TEXT NOT NULL,
  amount           NUMERIC(18, 6) NOT NULL,
  type             TEXT NOT NULL CHECK (type IN ('MINT', 'BURN')),
  status           TEXT NOT NULL CHECK (status IN ('PENDING', 'CONFIRMED', 'FAILED')),
  tx_hash          TEXT,
  block_number     BIGINT,
  error            TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_reward_events_user_id ON reward_events(user_id);
CREATE INDEX IF NOT EXISTS idx_reward_events_status  ON reward_events(status);
CREATE INDEX IF NOT EXISTS idx_users_original_user_id ON users(original_user_id);
CREATE INDEX IF NOT EXISTS idx_users_active_id ON users(id) WHERE is_active = TRUE;
