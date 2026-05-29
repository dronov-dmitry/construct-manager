-- ============================================================
-- ConstructManager — Full Database Deployment
-- Run this entire file in Supabase SQL Editor to deploy
-- the complete database schema, RLS policies, storage,
-- functions, and seed data.
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
    deadline TEXT NOT NULL DEFAULT '',
    state TEXT NOT NULL DEFAULT 'ON_SCHEDULE' CHECK (state IN ('ON_SCHEDULE', 'LATE', 'SOLVED')),
    finish_date TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_schedules_construction ON schedules(construction_uid);

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

-- ******************** RESPONSIBILITIES ********************
CREATE TABLE IF NOT EXISTS responsabilities (
    uid TEXT PRIMARY KEY,
    construction_uid TEXT NOT NULL REFERENCES constructions(uid) ON DELETE CASCADE,
    title TEXT NOT NULL DEFAULT '',
    description TEXT NOT NULL DEFAULT '',
    deadline TEXT NOT NULL DEFAULT '',
    state TEXT NOT NULL DEFAULT 'OPEN' CHECK (state IN ('OPEN', 'SOLVED')),
    responsible_email TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_resp_construction ON responsabilities(construction_uid);

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

-- ============================================================
-- Row Level Security Policies
-- ============================================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read users"
    ON users FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Users can insert own record"
    ON users FOR INSERT
    TO authenticated
    WITH CHECK (uid = auth.uid());

CREATE POLICY "Users can update own record"
    ON users FOR UPDATE
    TO authenticated
    USING (uid = auth.uid());

ALTER TABLE constructions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read their constructions"
    ON constructions FOR SELECT
    TO authenticated
    USING (owner_uid = auth.uid());

CREATE POLICY "Users can insert their constructions"
    ON constructions FOR INSERT
    TO authenticated
    WITH CHECK (owner_uid = auth.uid());

CREATE POLICY "Users can update their constructions"
    ON constructions FOR UPDATE
    TO authenticated
    USING (owner_uid = auth.uid());

CREATE POLICY "Users can delete their constructions"
    ON constructions FOR DELETE
    TO authenticated
    USING (owner_uid = auth.uid());

ALTER TABLE budgets ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read budgets of their constructions"
    ON budgets FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = budgets.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

CREATE POLICY "Users can insert budgets"
    ON budgets FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = budgets.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

CREATE POLICY "Users can update budgets"
    ON budgets FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = budgets.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

CREATE POLICY "Users can delete budgets"
    ON budgets FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = budgets.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

ALTER TABLE schedules ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read schedules of their constructions"
    ON schedules FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = schedules.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

CREATE POLICY "Users can insert schedules"
    ON schedules FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = schedules.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

CREATE POLICY "Users can update schedules"
    ON schedules FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = schedules.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

CREATE POLICY "Users can delete schedules"
    ON schedules FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = schedules.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

ALTER TABLE delays ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read delays of their constructions"
    ON delays FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = delays.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

CREATE POLICY "Users can insert delays"
    ON delays FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = delays.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

CREATE POLICY "Users can update delays"
    ON delays FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = delays.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

CREATE POLICY "Users can delete delays"
    ON delays FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = delays.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

ALTER TABLE responsabilities ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read responsibilities of their constructions"
    ON responsabilities FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = responsabilities.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

CREATE POLICY "Users can insert responsibilities"
    ON responsabilities FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = responsabilities.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

CREATE POLICY "Users can update responsibilities"
    ON responsabilities FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = responsabilities.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

CREATE POLICY "Users can delete responsibilities"
    ON responsabilities FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = responsabilities.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

ALTER TABLE photos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read photos of their constructions"
    ON photos FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = photos.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

CREATE POLICY "Users can insert photos"
    ON photos FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = photos.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

CREATE POLICY "Users can update photos"
    ON photos FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = photos.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

CREATE POLICY "Users can delete photos"
    ON photos FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = photos.construction_uid
            AND constructions.owner_uid = auth.uid()
        )
    );

-- ============================================================
-- Storage Policies
-- ============================================================

CREATE POLICY "authenticated_upload_photos"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'construction-photos'
);

CREATE POLICY "public_view_photos"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'construction-photos');

CREATE POLICY "authenticated_update_photos"
ON storage.objects
FOR UPDATE
TO authenticated
USING (bucket_id = 'construction-photos');

CREATE POLICY "authenticated_delete_photos"
ON storage.objects
FOR DELETE
TO authenticated
USING (bucket_id = 'construction-photos');

-- ============================================================
-- Functions & Triggers
-- ============================================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = ''
AS $$
BEGIN
    INSERT INTO public.users (uid, name, email, admin, is_email_verified, role)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data ->> 'name', split_part(NEW.email, '@', 1)),
        NEW.email,
        FALSE,
        COALESCE(NEW.email_confirmed_at IS NOT NULL, FALSE),
        COALESCE(NEW.raw_user_meta_data ->> 'role', 'executor')
    )
    ON CONFLICT (uid) DO UPDATE SET
        email = EXCLUDED.email,
        is_email_verified = COALESCE(NEW.email_confirmed_at IS NOT NULL, FALSE);
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

DROP TRIGGER IF EXISTS on_auth_user_updated ON auth.users;
CREATE TRIGGER on_auth_user_updated
    AFTER UPDATE OF email_confirmed_at ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

CREATE OR REPLACE FUNCTION public.get_stage_display(stage TEXT)
RETURNS TEXT
LANGUAGE SQL
IMMUTABLE
AS $$
    SELECT CASE stage
        WHEN 'ПОДГОТОВКА'  THEN 'Preparation'
        WHEN 'В_ИСПОЛНЕНИИ' THEN 'In Progress'
        WHEN 'ОТМЕНЕНО'    THEN 'Cancelled'
        WHEN 'ЗАВЕРШЕНО'   THEN 'Finished'
        ELSE stage
    END;
$$;

CREATE OR REPLACE FUNCTION public.get_construction_budget_total(construction_uid TEXT)
RETURNS REAL
LANGUAGE SQL
STABLE
AS $$
    SELECT COALESCE(SUM(value), 0)
    FROM public.budgets
    WHERE budgets.construction_uid = $1;
$$;

CREATE OR REPLACE FUNCTION public.update_construction_budget()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE public.constructions
    SET budget = get_construction_budget_total(
        COALESCE(NEW.construction_uid, OLD.construction_uid)
    )
    WHERE uid = COALESCE(NEW.construction_uid, OLD.construction_uid);
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_budget_update ON public.budgets;
CREATE TRIGGER trg_budget_update
    AFTER INSERT OR UPDATE OR DELETE ON public.budgets
    FOR EACH ROW
    EXECUTE FUNCTION public.update_construction_budget();

CREATE OR REPLACE FUNCTION public.check_schedule_deadline()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    deadline_date DATE;
BEGIN
    IF NEW.state != 'SOLVED' THEN
        BEGIN
            deadline_date := TO_DATE(NEW.deadline, 'DD/MM/YYYY');
            IF deadline_date < CURRENT_DATE THEN
                NEW.state := 'LATE';
            END IF;
        EXCEPTION WHEN OTHERS THEN
            NULL;
        END;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_schedule_deadline ON public.schedules;
CREATE TRIGGER trg_schedule_deadline
    BEFORE INSERT OR UPDATE ON public.schedules
    FOR EACH ROW
    EXECUTE FUNCTION public.check_schedule_deadline();

-- ============================================================
-- Manual steps required:
-- ============================================================
-- 1. Create Storage Bucket:
--    In Supabase Dashboard → Storage → Create bucket
--    Name: "construction-photos"
--    Public: YES
--    (or run: INSERT INTO storage.buckets (id, name, public)
--             VALUES ('construction-photos', 'construction-photos', true)
--             ON CONFLICT (id) DO NOTHING;)
--
-- 2. Enable Email Auth:
--    Supabase Dashboard → Authentication → Providers → Email
--
-- 3. Get API Keys:
--    Supabase Dashboard → Settings → API
--    Copy Project URL and anon/public key into the app.
-- ============================================================

SELECT 'ConstructManager database deployed successfully!' as result;
