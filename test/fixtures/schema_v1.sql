-- Mane schema v1, captured from the generated Drift schema before v0.1.5.
-- The migration test loads this file into a real SQLite database, inserts v1
-- rows, and then opens AppDatabase so the v2 migration runs against real data.
CREATE TABLE "space_records" ("id" TEXT NOT NULL, "name" TEXT NOT NULL, "color" INTEGER NOT NULL, "position" INTEGER NOT NULL DEFAULT 0, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, "deleted_at" INTEGER NULL, PRIMARY KEY ("id"));

CREATE TABLE "entry_records" ("id" TEXT NOT NULL, "space_id" TEXT NOT NULL REFERENCES space_records (id), "title" TEXT NOT NULL, "notes" TEXT NOT NULL DEFAULT '', "kind" TEXT NOT NULL, "date_key" INTEGER NULL, "end_date_key" INTEGER NULL, "start_minute" INTEGER NULL, "end_minute" INTEGER NULL, "all_day" INTEGER NOT NULL DEFAULT 0 CHECK ("all_day" IN (0, 1)), "status" TEXT NOT NULL, "recurrence_json" TEXT NULL, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, "deleted_at" INTEGER NULL, PRIMARY KEY ("id"));

CREATE TABLE "reminder_records" ("id" TEXT NOT NULL, "entry_id" TEXT NOT NULL REFERENCES entry_records (id), "offset_minutes" INTEGER NOT NULL, "enabled" INTEGER NOT NULL DEFAULT 1 CHECK ("enabled" IN (0, 1)), PRIMARY KEY ("id"));

CREATE TABLE "completion_records" ("entry_id" TEXT NOT NULL REFERENCES entry_records (id), "date_key" INTEGER NOT NULL, "created_at" INTEGER NOT NULL, PRIMARY KEY ("entry_id", "date_key"));

CREATE TABLE "shift_pattern_records" ("id" TEXT NOT NULL, "space_id" TEXT NOT NULL REFERENCES space_records (id), "name" TEXT NOT NULL, "cycle_days" INTEGER NOT NULL, "anchor_date_key" INTEGER NOT NULL, "slots_json" TEXT NOT NULL, "enabled" INTEGER NOT NULL DEFAULT 1 CHECK ("enabled" IN (0, 1)), "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, "deleted_at" INTEGER NULL, PRIMARY KEY ("id"));

CREATE TABLE "setting_records" ("key" TEXT NOT NULL, "value" TEXT NOT NULL, PRIMARY KEY ("key"));

PRAGMA user_version = 1;
