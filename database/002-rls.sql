-- ============================================================
-- ConstructManager — Row Level Security Policies
-- Run after 001-schema.sql
-- ============================================================

-- ******************** USERS ********************
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can read users" ON users;
CREATE POLICY "Anyone can read users"
    ON users FOR SELECT
    TO authenticated
    USING (true);

DROP POLICY IF EXISTS "Users can insert own record" ON users;
CREATE POLICY "Users can insert own record"
    ON users FOR INSERT
    TO authenticated
    WITH CHECK (uid = auth.uid()::text);

DROP POLICY IF EXISTS "Users can update own record" ON users;
CREATE POLICY "Users can update own record"
    ON users FOR UPDATE
    TO authenticated
    USING (uid = auth.uid()::text);

-- ******************** CONSTRUCTIONS ********************
ALTER TABLE constructions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can read their constructions" ON constructions;
CREATE POLICY "Users can read their constructions"
    ON constructions FOR SELECT
    TO authenticated
    USING (owner_uid = auth.uid()::text);

DROP POLICY IF EXISTS "Users can insert their constructions" ON constructions;
CREATE POLICY "Users can insert their constructions"
    ON constructions FOR INSERT
    TO authenticated
    WITH CHECK (owner_uid = auth.uid()::text);

DROP POLICY IF EXISTS "Users can update their constructions" ON constructions;
CREATE POLICY "Users can update their constructions"
    ON constructions FOR UPDATE
    TO authenticated
    USING (owner_uid = auth.uid()::text);

DROP POLICY IF EXISTS "Users can delete their constructions" ON constructions;
CREATE POLICY "Users can delete their constructions"
    ON constructions FOR DELETE
    TO authenticated
    USING (owner_uid = auth.uid()::text);

-- ******************** BUDGETS ********************
ALTER TABLE budgets ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can read budgets of their constructions" ON budgets;
CREATE POLICY "Users can read budgets of their constructions"
    ON budgets FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = budgets.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

DROP POLICY IF EXISTS "Users can insert budgets" ON budgets;
CREATE POLICY "Users can insert budgets"
    ON budgets FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = budgets.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

DROP POLICY IF EXISTS "Users can update budgets" ON budgets;
CREATE POLICY "Users can update budgets"
    ON budgets FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = budgets.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

DROP POLICY IF EXISTS "Users can delete budgets" ON budgets;
CREATE POLICY "Users can delete budgets"
    ON budgets FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = budgets.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

-- ******************** SCHEDULES ********************
ALTER TABLE schedules ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can read schedules of their constructions" ON schedules;
CREATE POLICY "Users can read schedules of their constructions"
    ON schedules FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = schedules.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

DROP POLICY IF EXISTS "Users can insert schedules" ON schedules;
CREATE POLICY "Users can insert schedules"
    ON schedules FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = schedules.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

DROP POLICY IF EXISTS "Users can update schedules" ON schedules;
CREATE POLICY "Users can update schedules"
    ON schedules FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = schedules.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

DROP POLICY IF EXISTS "Users can delete schedules" ON schedules;
CREATE POLICY "Users can delete schedules"
    ON schedules FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = schedules.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

-- ******************** DELAYS ********************
ALTER TABLE delays ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can read delays of their constructions" ON delays;
CREATE POLICY "Users can read delays of their constructions"
    ON delays FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = delays.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

DROP POLICY IF EXISTS "Users can insert delays" ON delays;
CREATE POLICY "Users can insert delays"
    ON delays FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = delays.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

DROP POLICY IF EXISTS "Users can update delays" ON delays;
CREATE POLICY "Users can update delays"
    ON delays FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = delays.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

DROP POLICY IF EXISTS "Users can delete delays" ON delays;
CREATE POLICY "Users can delete delays"
    ON delays FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = delays.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

-- ******************** RESPONSIBILITIES ********************
ALTER TABLE responsabilities ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can read responsibilities of their constructions" ON responsabilities;
CREATE POLICY "Users can read responsibilities of their constructions"
    ON responsabilities FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = responsabilities.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

DROP POLICY IF EXISTS "Users can insert responsibilities" ON responsabilities;
CREATE POLICY "Users can insert responsibilities"
    ON responsabilities FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = responsabilities.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

DROP POLICY IF EXISTS "Users can update responsibilities" ON responsabilities;
CREATE POLICY "Users can update responsibilities"
    ON responsabilities FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = responsabilities.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

DROP POLICY IF EXISTS "Users can delete responsibilities" ON responsabilities;
CREATE POLICY "Users can delete responsibilities"
    ON responsabilities FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = responsabilities.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

-- ******************** PHOTOS ********************
ALTER TABLE photos ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can read photos of their constructions" ON photos;
CREATE POLICY "Users can read photos of their constructions"
    ON photos FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = photos.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

DROP POLICY IF EXISTS "Users can insert photos" ON photos;
CREATE POLICY "Users can insert photos"
    ON photos FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = photos.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

DROP POLICY IF EXISTS "Users can update photos" ON photos;
CREATE POLICY "Users can update photos"
    ON photos FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = photos.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );

DROP POLICY IF EXISTS "Users can delete photos" ON photos;
CREATE POLICY "Users can delete photos"
    ON photos FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM constructions
            WHERE constructions.uid = photos.construction_uid
            AND constructions.owner_uid = auth.uid()::text
        )
    );
