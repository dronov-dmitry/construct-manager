# ConstructManager — Database

Полная схема базы данных Supabase для ConstructManager.

## Структура файлов

| Файл | Описание |
|------|----------|
| `001-schema.sql` | Все таблицы (users, constructions, budgets, schedules, delays, responsabilities, photos) + индексы |
| `002-rls.sql` | Row Level Security политики для всех таблиц |
| `003-storage.sql` | Storage bucket policies для загрузки фото |
| `004-functions.sql` | Триггеры (авто-создание user при регистрации, бюджет, дедлайн) |
| `005-seed.sql` | Тестовые данные для разработки |
| `deploy.sql` | Полный деплой (запускает все файлы по порядку) |

## Порядок развёртывания

### Способ 1: Supabase SQL Editor (рекомендуется)

1. Откройте **Supabase Dashboard** → **SQL Editor**
2. Создайте **New query**
3. Скопируйте содержимое файлов по порядку:
   - `001-schema.sql` → Run
   - `002-rls.sql` → Run
   - `003-storage.sql` → Run
   - `004-functions.sql` → Run
   - (опционально) `005-seed.sql` → Run
4. Или откройте `deploy.sql` и выполните его целиком

### Способ 2: через Supabase CLI

```bash
supabase link --project-ref <your-project-ref>
supabase db push
```

## После деплоя (ручные шаги)

### 1. Создать Storage Bucket

В Supabase Dashboard → **Storage** → **Create bucket**:
- **Name**: `construction-photos`
- **Public**: ON

Или SQL:
```sql
INSERT INTO storage.buckets (id, name, public)
VALUES ('construction-photos', 'construction-photos', true);
```

### 2. Включить Email Auth

Supabase Dashboard → **Authentication** → **Providers** → **Email** → Enable

### 3. Получить API ключи

Supabase Dashboard → **Settings** → **API**:
- `Project URL` — вставить в приложение (Supabase URL)
- `anon public` — вставить в приложение (Supabase Anon Key)

## Схема таблиц

```
users                  constructions          budgets
├── uid (PK)           ├── uid (PK)           ├── uid (PK)
├── name               ├── title              ├── construction_uid (FK)
├── email              ├── address            ├── title
├── admin              ├── type               ├── description
├── is_email_verified  ├── stage (enum)       └── value
└── role               ├── responsibles (JSON)
                       ├── owner_uid (FK)
                       ├── map_address
                       ├── information
                       ├── created_at
                       └── budget

schedules              delays                 responsabilities
├── uid (PK)           ├── uid (PK)           ├── uid (PK)
├── construction_uid   ├── construction_uid   ├── construction_uid
├── title              ├── schedule_uid       ├── title
├── deadline           ├── title              ├── description
├── state (enum)       ├── reason             ├── deadline
├── finish_date        ├── is_excusable       ├── state (enum)
└── created_at         ├── is_compensable     └── responsible_email
                       ├── is_concurrent
                       ├── is_critical
                       ├── days
                       ├── additional_info
                       ├── finished
                       └── created_at

photos
├── id (UUID PK)
├── uid
├── url
├── description
├── construction_uid (FK)
├── created_at
├── file_size
└── mime_type
```
