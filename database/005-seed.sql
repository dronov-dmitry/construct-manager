-- ============================================================
-- ConstructManager — Seed / Sample Data
-- Run after 004-functions.sql for testing purposes only
-- ============================================================

-- Add sample users (replace with real auth users)
INSERT INTO public.users (uid, name, email, admin, is_email_verified, role) VALUES
    ('demo-user-1', 'Иван Иванов', 'ivan@example.com', TRUE, TRUE, 'customer'),
    ('demo-user-2', 'Пётр Петров', 'petr@example.com', FALSE, TRUE, 'executor'),
    ('demo-user-3', 'Анна Сидорова', 'anna@example.com', FALSE, TRUE, 'contractor')
ON CONFLICT (uid) DO NOTHING;

-- Add sample constructions
INSERT INTO public.constructions (uid, title, address, type, stage, owner_uid, map_address, information) VALUES
    ('demo-constr-1', 'Ремонт офиса', 'ул. Ленина, 10', 'Офисный', 'ПОДГОТОВКА', 'demo-user-1', '55.7558,37.6173', 'Плановый ремонт офисного помещения'),
    ('demo-constr-2', 'Строительство дома', 'ул. Садовая, 25', 'Жилой', 'В_ИСПОЛНЕНИИ', 'demo-user-1', '55.7614,37.6249', 'Индивидуальный жилой дом'),
    ('demo-constr-3', 'Реконструкция склада', 'пр. Мира, 5', 'Промышленный', 'ЗАВЕРШЕНО', 'demo-user-1', '55.7500,37.6000', 'Складской комплекс завершен')
ON CONFLICT (uid) DO NOTHING;

-- Add sample budgets
INSERT INTO public.budgets (uid, construction_uid, title, description, value) VALUES
    ('demo-budg-1', 'demo-constr-1', 'Материалы', 'Закупка стройматериалов', 500000),
    ('demo-budg-2', 'demo-constr-1', 'Работа', 'Оплата рабочим', 300000),
    ('demo-budg-3', 'demo-constr-2', 'Фундамент', 'Заливка фундамента', 1500000),
    ('demo-budg-4', 'demo-constr-2', 'Кровля', 'Кровельные работы', 800000)
ON CONFLICT (uid) DO NOTHING;

-- Add sample schedules
INSERT INTO public.schedules (uid, construction_uid, title, deadline, state) VALUES
    ('demo-sched-1', 'demo-constr-1', 'Демонтаж', '01/06/2026', 'SOLVED'),
    ('demo-sched-2', 'demo-constr-1', 'Отделка', '01/08/2026', 'ON_SCHEDULE'),
    ('demo-sched-3', 'demo-constr-2', 'Фундаментные работы', '15/04/2026', 'LATE'),
    ('demo-sched-4', 'demo-constr-2', 'Возведение стен', '15/07/2026', 'ON_SCHEDULE')
ON CONFLICT (uid) DO NOTHING;

-- Add sample delays
INSERT INTO public.delays (uid, construction_uid, schedule_uid, title, reason, is_excusable, is_compensable, days, additional_info) VALUES
    ('demo-delay-1', 'demo-constr-2', 'demo-sched-3', 'Задержка поставки бетона', 'Срыв поставки поставщиком', TRUE, TRUE, 14, 'Поставщик не уложился в сроки по договору')
ON CONFLICT (uid) DO NOTHING;

-- Add sample responsibilities
INSERT INTO public.responsabilities (uid, construction_uid, title, description, deadline, state, responsible_email) VALUES
    ('demo-resp-1', 'demo-constr-1', 'Закупка материалов', 'Составить смету и закупить материалы', '15/06/2026', 'OPEN', 'petr@example.com'),
    ('demo-resp-2', 'demo-constr-1', 'Контроль качества', 'Проверка качества отделочных работ', '01/08/2026', 'OPEN', 'anna@example.com')
ON CONFLICT (uid) DO NOTHING;
