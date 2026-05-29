-- ============================================================
-- ConstructManager — Helper Functions & Triggers
-- Run after 002-rls.sql
-- ============================================================

-- ******************** AUTO-CREATE USER ON SIGNUP ********************
-- Trigger: when a new user signs up via Supabase Auth,
-- automatically create a matching record in the public.users table.
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

-- Apply trigger to auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- Also update on email verification
DROP TRIGGER IF EXISTS on_auth_user_updated ON auth.users;
CREATE TRIGGER on_auth_user_updated
    AFTER UPDATE OF email_confirmed_at ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- ******************** CONSTRUCTION STAGE HELPER ********************
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

-- ******************** BUDGET TOTALS ********************
CREATE OR REPLACE FUNCTION public.get_construction_budget_total(construction_uid TEXT)
RETURNS REAL
LANGUAGE SQL
STABLE
AS $$
    SELECT COALESCE(SUM(value), 0)
    FROM public.budgets
    WHERE budgets.construction_uid = $1;
$$;

-- ******************** AUTO-UPDATE CONSTRUCTION BUDGET ********************
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

-- ******************** SCHEDULE STATE TRIGGER ********************
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

-- ******************** VERIFICATION ********************
SELECT 'Functions and triggers created successfully' as status;
