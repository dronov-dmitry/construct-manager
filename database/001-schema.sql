-- ============================================================
-- ConstructManager — Full Database Schema for Supabase
-- Apply in order: 001 → 002 → 003 → 004
-- ============================================================

-- ******************** USERS ********************
CREATE TABLE IF NOT EXISTS users (
    uid TEXT PRIMARY KEY,
    name TEXT NOT NULL DEFAULT '',
    email TEXT NOT NULL UNIQUE,
    admin BOOLEAN NOT NULL DEFAULT FALSE,
    is_email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    role TEXT NOT NULL DEFAULT 'executor' CHECK (role IN ('executor', 'customer', 'contractor')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- ******************** CONSTRUCTIONS ********************
CREATE TABLE IF NOT EXISTS constructions (
    uid TEXT PRIMARY KEY,
    title TEXT NOT NULL DEFAULT '',
    address TEXT NOT NULL DEFAULT '',
    type TEXT NOT NULL DEFAULT '',
    stage TEXT NOT NULL DEFAULT 'ПОДГОТОВКА' CHECK (stage IN ('ПОДГОТОВКА', 'В_ИСПОЛНЕНИИ', 'ОТМЕНЕНО', 'ЗАВЕРШЕНО')),
    responsibles JSONB NOT NULL DEFAULT '[]'::jsonb,
    owner_uid TEXT NOT NULL REFERENCES users(uid) ON DELETE CASCADE,
    map_address TEXT NOT NULL DEFAULT '',
    information TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    budget REAL
);

CREATE INDEX IF NOT EXISTS idx_constructions_owner ON constructions(owner_uid);
CREATE INDEX IF NOT EXISTS idx_constructions_stage ON constructions(stage);
CREATE INDEX IF NOT EXISTS idx_constructions_created ON constructions(created_at DESC);

-- ******************** BUDGETS ********************
CREATE TABLE IF NOT EXISTS budgets (
    uid TEXT PRIMARY KEY,
    construction_uid TEXT NOT NULL REFERENCES constructions(uid) ON DELETE CASCADE,
    title TEXT NOT NULL DEFAULT '',
    description TEXT NOT NULL DEFAULT '',
    value REAL NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_budgets_construction ON budgets(construction_uid);

-- ******************** SCHEDULES ********************
CREATE TABLE IF NOT EXISTS schedules (
    uid TEXT PRIMARY KEY,
    construction_uid TEXT NOT NULL REFERENCES constructions(uid) ON DELETE CASCADE,
    title TEXT NOT NULL DEFAULT '',
    start_date TEXT,
    deadline TEXT NOT NULL DEFAULT '',
    state TEXT NOT NULL DEFAULT 'ON_SCHEDULE' CHECK (state IN ('ON_SCHEDULE', 'LATE', 'SOLVED')),
    finish_date TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_schedules_construction ON schedules(construction_uid);

ALTER TABLE schedules ADD COLUMN IF NOT EXISTS start_date TEXT;

-- ******************** DELAYS ********************
CREATE TABLE IF NOT EXISTS delays (
    uid TEXT PRIMARY KEY,
    construction_uid TEXT NOT NULL REFERENCES constructions(uid) ON DELETE CASCADE,
    schedule_uid TEXT NOT NULL REFERENCES schedules(uid) ON DELETE CASCADE,
    title TEXT NOT NULL DEFAULT '',
    reason TEXT NOT NULL DEFAULT '',
    is_excusable BOOLEAN NOT NULL DEFAULT FALSE,
    is_compensable BOOLEAN NOT NULL DEFAULT FALSE,
    is_concurrent BOOLEAN NOT NULL DEFAULT FALSE,
    is_critical BOOLEAN NOT NULL DEFAULT FALSE,
    days INT NOT NULL DEFAULT 0,
    additional_info TEXT NOT NULL DEFAULT '',
    finished BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_delays_construction ON delays(construction_uid);
CREATE INDEX IF NOT EXISTS idx_delays_schedule ON delays(schedule_uid);

-- ******************** RESPONSIBILITIES (removed) ********************

-- ******************** PHOTOS ********************
CREATE TABLE IF NOT EXISTS photos (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    uid TEXT NOT NULL,
    url TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    construction_uid TEXT NOT NULL REFERENCES constructions(uid) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    file_size BIGINT,
    mime_type TEXT DEFAULT 'image/jpeg',
    uploaded_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_photos_construction ON photos(construction_uid);
CREATE INDEX IF NOT EXISTS idx_photos_uid ON photos(uid);
