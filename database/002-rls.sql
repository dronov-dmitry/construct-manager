-- ============================================================
-- ConstructManager — Row Level Security Policies
-- Run after 001-schema.sql
-- ============================================================

-- ******************** USERS ********************
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

-- ******************** CONSTRUCTIONS ********************
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

-- ******************** BUDGETS ********************
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

-- ******************** SCHEDULES ********************
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

-- ******************** DELAYS ********************
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

-- ******************** RESPONSIBILITIES ********************
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

-- ******************** PHOTOS ********************
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
