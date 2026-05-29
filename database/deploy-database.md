# Развёртывание базы данных на Supabase

Пошаговая инструкция для деплоя всех таблиц, политик, триггеров и тестовых данных ConstructManager.

---

## 1. Создайте проект Supabase

1. Перейдите на [supabase.com](https://supabase.com) и войдите в аккаунт
2. Нажмите **New project**
3. Укажите:
   - **Name**: `construct-manager` (произвольно)
   - **Database Password**: надёжный пароль (сохраните его)
   - **Region**: ближайший к вам регион (например, `eu-central-1`)
4. Дождитесь создания базы (1–2 минуты)

## 2. Разверните схему через SQL Editor

### Вариант A — всё сразу (рекомендуется)

1. В Supabase Dashboard → **SQL Editor**
2. Нажмите **New query**
3. Откройте файл `database/deploy.sql`, скопируйте всё содержимое → вставьте в редактор
4. Нажмите **Run** — выполнятся все 5 файлов по порядку

### Вариант B — по файлам (для отладки)

| Шаг | Файл | Что делает |
|-----|------|------------|
| 1 | `001-schema.sql` | Создаёт 7 таблиц (`users`, `constructions`, `budgets`, `schedules`, `delays`, `responsabilities`, `photos`) + индексы |
| 2 | `002-rls.sql` | Включает Row Level Security на всех таблицах и создаёт политики доступа по `owner_uid` |
| 3 | `003-storage.sql` | Создаёт Storage bucket `construction-photos` и политики для загрузки/скачивания |
| 4 | `004-functions.sql` | Создаёт триггеры: авто-создание пользователя, авто-расчёт бюджета, проверка дедлайнов |
| 5 | `005-seed.sql` | **(Опционально)** Заполняет тестовыми данными (3 пользователя, 3 проекта, бюджет, график, задержки, назначения) |

Выполняйте последовательно: после каждого **Run** дождитесь `Success`, затем переходите к следующему.

## 3. Настройте аутентификацию

1. Supabase Dashboard → **Authentication** → **Providers**
2. Включите **Email** (основной способ входа)
3. При необходимости включите другие провайдеры (Google, GitHub и т.д.)
4. В **Settings → Auth Settings** настройте:
   - **Site URL**: URL вашего приложения (для прода — домен, для dev — `http://localhost:3000`)
   - **Redirect URLs**: добавьте URL для OAuth (если используете)

## 4. Включите Realtime (опционально)

Если нужно, чтобы изменения синхронизировались в реальном времени:

```sql
-- Включаем realtime для нужных таблиц
alter publication supabase_realtime add table constructions;
alter publication supabase_realtime add table budgets;
alter publication supabase_realtime add table schedules;
```

Выполните в **SQL Editor**.

## 5. Создайте Storage Bucket

Если не выполнили `003-storage.sql` на шаге 2:

1. Supabase Dashboard → **Storage** → **Create bucket**
2. **Name**: `construction-photos`
3. **Public**: ON

Или SQL:
```sql
INSERT INTO storage.buckets (id, name, public)
VALUES ('construction-photos', 'construction-photos', true);
```

## 6. Получите API-ключи для приложения

1. Supabase Dashboard → **Settings** → **API**
2. Скопируйте:
   - **Project URL** → вставьте в приложение как Supabase URL
   - **anon public** → вставьте в приложение как Supabase Anon Key

## 7. Проверьте развёртывание

Выполните в SQL Editor проверочный запрос:

```sql
-- Проверка таблиц
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public';

-- Проверка триггеров
SELECT trigger_name, event_manipulation, event_object_table
FROM information_schema.triggers
WHERE trigger_schema = 'public';

-- Проверка тестовых данных (если запускали seed)
SELECT uid, name, email FROM users;
SELECT uid, title, stage FROM constructions;
SELECT uid, title, value FROM budgets;
```

Ожидаемый результат — все таблицы созданы, триггеры активны, тестовые данные присутствуют (если применяли seed).

---

## Устранение проблем

| Ошибка | Решение |
|--------|---------|
| `relation "public.users" already exists` | Повторный запуск — можно игнорировать, если схема не изменилась |
| `bucket "construction-photos" already exists` | Бакет уже создан — всё в порядке |
| Ошибка выполнения `deploy.sql` | Выполняйте файлы по одному (Вариант B), чтобы увидеть, на каком шаге проблема |
| RLS блокирует запросы | Убедитесь, что политики в `002-rls.sql` выполнены и включены |
| Seed не вставил данные | Проверьте, что `auth.users` содержит пользователей с указанными UID |
