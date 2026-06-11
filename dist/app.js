const translations = {
  en: {
    "nav.platform": "Platform",
    "nav.workflow": "Workflow",
    "nav.supabase": "Supabase guide",
    "hero.eyebrow": "Construction control for field teams",
    "hero.title": "Run every construction project from one operational cockpit.",
    "hero.text": "ConstructManager brings budgets, deadlines, responsibilities, photos, maps and Supabase-backed access into one mobile-first workspace for contractors, customers and executors.",
    "hero.primary": "Explore features",
    "hero.secondary": "Deploy database",
    "proof.modules": "core project modules",
    "proof.security": "owner-based data policies",
    "proof.mobile": "Flutter-first workflow",
    "mock.projects": "My Projects",
    "mock.stage1": "In progress",
    "mock.stage2": "Prep",
    "mock.stage3": "Done",
    "mock.projectType": "Residential complex",
    "mock.projectName": "North Gate A12",
    "mock.badge": "On site",
    "mock.budget": "Budget",
    "mock.deadline": "Deadline",
    "mock.schedule": "Schedule health",
    "ops.title": "Live project desk",
    "ops.event1": "Critical delay marked compensable",
    "ops.event2": "New roof progress photo uploaded",
    "ops.event3": "Budget total recalculated by trigger",
    "platform.eyebrow": "What the app covers",
    "platform.title": "A complete field-to-office loop.",
    "platform.text": "Every module maps to a real workflow already present in the Flutter app.",
    "features.projects.title": "Project portfolio",
    "features.projects.text": "Create construction objects, store addresses, types, responsible people and stage statuses from preparation to completion.",
    "features.budget.title": "Budget control",
    "features.budget.text": "Track budget items, descriptions and values while database triggers keep project totals consistent.",
    "features.schedule.title": "Schedule and delays",
    "features.schedule.text": "Manage deadlines, solved states and delay claims with flags for excusable, compensable, concurrent and critical cases.",
    "features.responsibility.title": "Responsibility matrix",
    "features.responsibility.text": "Assign tasks to responsible emails, track open or solved status and keep accountability visible.",
    "features.photos.title": "Photo evidence",
    "features.photos.text": "Upload site photos to Supabase Storage, add descriptions and review visual progress from a compact gallery.",
    "features.map.title": "Map context",
    "features.map.text": "Save map addresses and view project location context with OpenStreetMap-based map screens.",
    "workflow.eyebrow": "Designed for adoption",
    "workflow.title": "A workflow your site team can actually keep updated.",
    "workflow.step1.title": "Connect Supabase",
    "workflow.step1.text": "Paste Project URL and anon key in app settings. Authentication and storage are ready for the team.",
    "workflow.step2.title": "Create the project",
    "workflow.step2.text": "Add title, address, type, stage, owner and responsible people. Then open the object workspace.",
    "workflow.step3.title": "Run daily control",
    "workflow.step3.text": "Update budget, schedule, responsibility, delays, photos and map notes from the same project view.",
    "supabase.eyebrow": "Deployment tab",
    "supabase.title": "Supabase database deployment guide.",
    "supabase.text": "Follow this checklist to deploy tables, policies, triggers, storage and test data for ConstructManager.",
    "tabs.dashboard": "Dashboard",
    "tabs.sql": "SQL files",
    "tabs.verify": "Verify",
    "deploy.create.title": "Create a Supabase project",
    "deploy.create.text": "Open Supabase, choose New project, set a strong database password and select the closest region.",
    "deploy.sql.title": "Deploy database schema",
    "deploy.sql.text": "Go to the SQL files tab, open deploy.sql, copy the entire content and run it in Supabase SQL Editor. This creates all tables, security policies, storage rules and triggers.",
    "deploy.auth.title": "Enable Email authentication",
    "deploy.auth.text": "Go to Authentication → Providers and enable Email. Add Site URL and Redirect URLs if OAuth is used.",
    "deploy.keys.title": "Copy API credentials",
    "deploy.keys.text": "Go to Project Settings (gear icon, bottom-left) → Data API tab in your Supabase dashboard. Copy the Project URL (top of page — this is NOT the browser URL, it looks like https://<project-ref>.supabase.co; remove /rest/v1 suffix if present) and the anon public key (under Project API keys, starts with eyJ). Paste both in the ConstructManager settings screen.",
    "sql.recommended.title": "Recommended: deploy all at once",
    "sql.recommended.text": "This single file contains the complete database. Open Supabase SQL Editor, create a new query, paste the entire content below and press Run.",
    "sql.manual.title": "Manual order for debugging",
    "sql.file1": "tables and indexes",
    "sql.file2": "Row Level Security policies",
    "sql.file3": "photo bucket and policies",
    "sql.file4": "triggers and helper functions",
    "sql.file5": "optional demo data",
    "sql.deploy": "schema + RLS + storage + functions",
    "verify.storage.title": "Storage bucket",
    "verify.storage.text": "Confirm that the public bucket construction-photos exists in Storage.",
    "verify.realtime.title": "Optional realtime",
    "verify.realtime.text": "Enable realtime for constructions, budgets and schedules if live synchronization is required.",
    "verify.query.title": "Run verification queries",
    "verify.trouble.title": "Troubleshooting",
    "verify.trouble1": "The script was already executed; continue if the schema is correct.",
    "verify.trouble2": "Check that 002-rls.sql ran and the current user owns the project rows.",
    "verify.trouble3": "Create matching auth.users first or skip 005-seed.sql in production.",
    "footer.supabase": "Supabase guide",
    "footer.home": "Home",
    "footer.back": "Back to top"
  },
  de: {
    "nav.platform": "Plattform",
    "nav.workflow": "Ablauf",
    "nav.supabase": "Supabase-Anleitung",
    "hero.eyebrow": "Baukontrolle für Teams vor Ort",
    "hero.title": "Steuern Sie jedes Bauprojekt aus einem operativen Cockpit.",
    "hero.text": "ConstructManager bündelt Budgets, Termine, Verantwortlichkeiten, Fotos, Karten und Supabase-Zugriff in einem Mobile-First-Arbeitsbereich für Auftragnehmer, Kunden und Ausführende.",
    "hero.primary": "Funktionen ansehen",
    "hero.secondary": "Datenbank deployen",
    "proof.modules": "Kernmodule für Projekte",
    "proof.security": "Datenrichtlinien pro Eigentümer",
    "proof.mobile": "Flutter-First-Ablauf",
    "mock.projects": "Meine Projekte",
    "mock.stage1": "In Arbeit",
    "mock.stage2": "Vorbereitung",
    "mock.stage3": "Fertig",
    "mock.projectType": "Wohnkomplex",
    "mock.projectName": "North Gate A12",
    "mock.badge": "Baustelle",
    "mock.budget": "Budget",
    "mock.deadline": "Termin",
    "mock.schedule": "Terminstatus",
    "ops.title": "Live-Projektpult",
    "ops.event1": "Kritische Verzögerung als kompensierbar markiert",
    "ops.event2": "Neues Dach-Fortschrittsfoto hochgeladen",
    "ops.event3": "Budgetsumme per Trigger neu berechnet",
    "platform.eyebrow": "Was die App abdeckt",
    "platform.title": "Eine komplette Schleife von Baustelle bis Büro.",
    "platform.text": "Jedes Modul entspricht einem realen Workflow, der bereits in der Flutter-App vorhanden ist.",
    "features.projects.title": "Projektportfolio",
    "features.projects.text": "Legen Sie Bauobjekte an, speichern Sie Adressen, Typen, Verantwortliche und Status von Vorbereitung bis Abschluss.",
    "features.budget.title": "Budgetkontrolle",
    "features.budget.text": "Verfolgen Sie Budgetpositionen, Beschreibungen und Werte, während Datenbank-Trigger Projektsummen konsistent halten.",
    "features.schedule.title": "Zeitplan und Verzögerungen",
    "features.schedule.text": "Verwalten Sie Termine, erledigte Zustände und Verzögerungen mit Flags für entschuldbar, kompensierbar, gleichzeitig und kritisch.",
    "features.responsibility.title": "Verantwortungsmatrix",
    "features.responsibility.text": "Weisen Sie Aufgaben per E-Mail zu, verfolgen Sie offene oder erledigte Zustände und halten Sie Zuständigkeit sichtbar.",
    "features.photos.title": "Fotodokumentation",
    "features.photos.text": "Laden Sie Baustellenfotos in Supabase Storage hoch, ergänzen Sie Beschreibungen und prüfen Sie Fortschritt in einer kompakten Galerie.",
    "features.map.title": "Kartenkontext",
    "features.map.text": "Speichern Sie Kartenadressen und sehen Sie den Standortkontext mit OpenStreetMap-basierten Kartenansichten.",
    "workflow.eyebrow": "Für Akzeptanz gestaltet",
    "workflow.title": "Ein Ablauf, den Ihr Baustellenteam wirklich aktuell halten kann.",
    "workflow.step1.title": "Supabase verbinden",
    "workflow.step1.text": "Fügen Sie Project URL und anon key in den App-Einstellungen ein. Authentifizierung und Storage sind bereit.",
    "workflow.step2.title": "Projekt erstellen",
    "workflow.step2.text": "Erfassen Sie Titel, Adresse, Typ, Status, Eigentümer und Verantwortliche. Danach öffnen Sie den Objektarbeitsbereich.",
    "workflow.step3.title": "Tägliche Kontrolle",
    "workflow.step3.text": "Aktualisieren Sie Budget, Zeitplan, Verantwortung, Verzögerungen, Fotos und Kartennotizen aus derselben Projektansicht.",
    "supabase.eyebrow": "Deployment-Tab",
    "supabase.title": "Anleitung zum Supabase-Datenbankdeployment.",
    "supabase.text": "Nutzen Sie diese Checkliste, um Tabellen, Policies, Trigger, Storage und Testdaten für ConstructManager bereitzustellen.",
    "tabs.dashboard": "Dashboard",
    "tabs.sql": "SQL-Dateien",
    "tabs.verify": "Prüfen",
    "deploy.create.title": "Supabase-Projekt erstellen",
    "deploy.create.text": "Öffnen Sie Supabase, wählen Sie New project, setzen Sie ein starkes Datenbankpasswort und wählen Sie die nächstgelegene Region.",
    "deploy.sql.title": "Datenbankschema deployen",
    "deploy.sql.text": "Gehen Sie zum Tab SQL files, öffnen Sie deploy.sql, kopieren Sie den gesamten Inhalt und führen Sie ihn im Supabase SQL Editor aus. Dies erstellt alle Tabellen, Sicherheitsrichtlinien, Speicherregeln und Trigger.",
    "deploy.auth.title": "E-Mail-Authentifizierung aktivieren",
    "deploy.auth.text": "Gehen Sie zu Authentication → Providers und aktivieren Sie Email. Ergänzen Sie Site URL und Redirect URLs, falls OAuth genutzt wird.",
    "deploy.keys.title": "API-Zugangsdaten kopieren",
    "deploy.keys.text": "Gehen Sie zu Project Settings (Zahnrad-Symbol, unten links) → Data API-Tab im Supabase-Dashboard. Kopieren Sie die Project URL (oben auf der Seite — das ist NICHT die Browser-URL, sieht aus wie https://<project-ref>.supabase.co; entfernen Sie ggf. das /rest/v1-Suffix) und den anon public key (unter Project API keys, beginnt mit eyJ). Fügen Sie beides in den ConstructManager-Einstellungen ein.",
    "sql.recommended.title": "Empfohlen: alles auf einmal deployen",
    "sql.recommended.text": "Diese einzelne Datei enthält die gesamte Datenbank. Öffnen Sie den Supabase SQL Editor, erstellen Sie eine neue Query, fügen Sie den gesamten Inhalt unten ein und drücken Sie Run.",
    "sql.manual.title": "Manuelle Reihenfolge für Debugging",
    "sql.file1": "Tabellen und Indizes",
    "sql.file2": "Row-Level-Security-Policies",
    "sql.file3": "Foto-Bucket und Policies",
    "sql.file4": "Trigger und Hilfsfunktionen",
    "sql.file5": "optionale Demodaten",
    "sql.deploy": "Schema + RLS + Storage + Funktionen",
    "verify.storage.title": "Storage-Bucket",
    "verify.storage.text": "Prüfen Sie, dass der öffentliche Bucket construction-photos in Storage existiert.",
    "verify.realtime.title": "Optionales Realtime",
    "verify.realtime.text": "Aktivieren Sie Realtime für constructions, budgets und schedules, falls Live-Synchronisierung benötigt wird.",
    "verify.query.title": "Prüfabfragen ausführen",
    "verify.trouble.title": "Fehlerbehebung",
    "verify.trouble1": "Das Skript wurde bereits ausgeführt; fahren Sie fort, wenn das Schema korrekt ist.",
    "verify.trouble2": "Prüfen Sie, dass 002-rls.sql ausgeführt wurde und der aktuelle Nutzer Eigentümer der Projektdaten ist.",
    "verify.trouble3": "Erstellen Sie zuerst passende auth.users oder überspringen Sie 005-seed.sql in Produktion.",
    "footer.supabase": "Supabase-Anleitung",
    "footer.home": "Startseite",
    "footer.back": "Nach oben"
  },
  ru: {
    "nav.platform": "Платформа",
    "nav.workflow": "Процесс",
    "nav.supabase": "Инструкция Supabase",
    "hero.eyebrow": "Контроль строительства для полевых команд",
    "hero.title": "Управляйте каждым строительным проектом из единого оперативного штаба.",
    "hero.text": "ConstructManager объединяет бюджеты, сроки, ответственность, фото, карты и доступ через Supabase в мобильном рабочем пространстве для подрядчиков, заказчиков и исполнителей.",
    "hero.primary": "Посмотреть функции",
    "hero.secondary": "Развернуть базу",
    "proof.modules": "ключевых модулей проекта",
    "proof.security": "политики доступа по владельцу",
    "proof.mobile": "Flutter-first workflow",
    "mock.projects": "Мои проекты",
    "mock.stage1": "В исполнении",
    "mock.stage2": "Подготовка",
    "mock.stage3": "Готово",
    "mock.projectType": "Жилой комплекс",
    "mock.projectName": "North Gate A12",
    "mock.badge": "На объекте",
    "mock.budget": "Бюджет",
    "mock.deadline": "Срок",
    "mock.schedule": "Состояние графика",
    "ops.title": "Живая панель проекта",
    "ops.event1": "Критическая задержка отмечена как компенсируемая",
    "ops.event2": "Загружено новое фото прогресса кровли",
    "ops.event3": "Сумма бюджета пересчитана триггером",
    "platform.eyebrow": "Что покрывает приложение",
    "platform.title": "Полный контур от стройплощадки до офиса.",
    "platform.text": "Каждый модуль соответствует реальному workflow, который уже есть во Flutter-приложении.",
    "features.projects.title": "Портфель проектов",
    "features.projects.text": "Создавайте строительные объекты, храните адреса, типы, ответственных и статусы стадий от подготовки до завершения.",
    "features.budget.title": "Контроль бюджета",
    "features.budget.text": "Ведите статьи бюджета, описания и суммы, а триггеры базы данных будут поддерживать итог проекта в актуальном состоянии.",
    "features.schedule.title": "График и задержки",
    "features.schedule.text": "Управляйте сроками, выполнением и задержками с признаками уважительности, компенсации, совпадения и критичности.",
    "features.responsibility.title": "Матрица ответственности",
    "features.responsibility.text": "Назначайте задачи на email ответственных, отслеживайте открытый или решенный статус и держите зоны ответственности на виду.",
    "features.photos.title": "Фотофиксация",
    "features.photos.text": "Загружайте фото объекта в Supabase Storage, добавляйте описания и просматривайте прогресс в компактной галерее.",
    "features.map.title": "Контекст на карте",
    "features.map.text": "Сохраняйте адреса на карте и смотрите контекст расположения объекта на экранах с OpenStreetMap.",
    "workflow.eyebrow": "Сделано для внедрения",
    "workflow.title": "Процесс, который команда на объекте действительно сможет поддерживать.",
    "workflow.step1.title": "Подключите Supabase",
    "workflow.step1.text": "Вставьте Project URL и anon key в настройках приложения. Авторизация и хранилище будут готовы для команды.",
    "workflow.step2.title": "Создайте проект",
    "workflow.step2.text": "Добавьте название, адрес, тип, стадию, владельца и ответственных. Затем откройте рабочее пространство объекта.",
    "workflow.step3.title": "Ведите ежедневный контроль",
    "workflow.step3.text": "Обновляйте бюджет, график, ответственность, задержки, фото и заметки карты из одного экрана проекта.",
    "supabase.eyebrow": "Подзакладка развёртывания",
    "supabase.title": "Инструкция по развёртыванию базы Supabase.",
    "supabase.text": "Следуйте чеклисту, чтобы развернуть таблицы, политики, триггеры, хранилище и тестовые данные для ConstructManager.",
    "tabs.dashboard": "Dashboard",
    "tabs.sql": "SQL-файлы",
    "tabs.verify": "Проверка",
    "deploy.create.title": "Создайте проект Supabase",
    "deploy.create.text": "Откройте Supabase, выберите New project, задайте надежный пароль базы данных и ближайший регион.",
    "deploy.sql.title": "Разверните схему базы данных",
    "deploy.sql.text": "Перейдите на вкладку SQL files, откройте deploy.sql, скопируйте всё содержимое и выполните в Supabase SQL Editor. Это создаст все таблицы, политики безопасности, правила хранилища и триггеры.",
    "deploy.auth.title": "Включите Email-аутентификацию",
    "deploy.auth.text": "Перейдите в Authentication → Providers и включите Email. Добавьте Site URL и Redirect URLs, если используется OAuth.",
    "deploy.keys.title": "Скопируйте API-ключи",
    "deploy.keys.text": "Перейдите в Project Settings (иконка шестерёнки внизу слева) → вкладка Data API в дашборде Supabase. Скопируйте Project URL (вверху страницы — это НЕ адресная строка браузера, выглядит как https://<project-ref>.supabase.co; если есть /rest/v1 на конце — удалите) и anon public key (в разделе Project API keys, начинается с eyJ). Вставьте их в настройки ConstructManager.",
    "sql.recommended.title": "Рекомендуется: развернуть всё сразу",
    "sql.recommended.text": "Этот один файл содержит всю базу данных. Откройте Supabase SQL Editor, создайте новый запрос, вставьте всё содержимое ниже и нажмите Run.",
    "sql.manual.title": "Ручной порядок для отладки",
    "sql.file1": "таблицы и индексы",
    "sql.file2": "политики Row Level Security",
    "sql.file3": "bucket для фото и политики",
    "sql.file4": "триггеры и вспомогательные функции",
    "sql.file5": "опциональные демоданные",
    "sql.deploy": "схема + RLS + storage + функции",
    "verify.storage.title": "Storage bucket",
    "verify.storage.text": "Убедитесь, что публичный bucket construction-photos существует в Storage.",
    "verify.realtime.title": "Опциональный realtime",
    "verify.realtime.text": "Включите realtime для constructions, budgets и schedules, если нужна живая синхронизация.",
    "verify.query.title": "Запустите проверочные запросы",
    "verify.trouble.title": "Устранение проблем",
    "verify.trouble1": "Скрипт уже выполнялся; продолжайте, если схема базы корректна.",
    "verify.trouble2": "Проверьте, что 002-rls.sql выполнен и текущий пользователь владеет строками проекта.",
    "verify.trouble3": "Сначала создайте соответствующих auth.users или не запускайте 005-seed.sql в production.",
    "footer.supabase": "Инструкция Supabase",
    "footer.home": "Головна",
    "footer.back": "Вгору"
  },
  uk: {
    "nav.platform": "Платформа",
    "nav.workflow": "Процес",
    "nav.supabase": "Інструкція Supabase",
    "hero.eyebrow": "Контроль будівництва для польових команд",
    "hero.title": "Керуйте кожним будівельним проєктом з єдиного оперативного штабу.",
    "hero.text": "ConstructManager об'єднує бюджети, терміни, відповідальність, фото, карти та доступ через Supabase в мобільному робочому просторі для підрядників, замовників та виконавців.",
    "hero.primary": "Переглянути функції",
    "hero.secondary": "Розгорнути базу",
    "proof.modules": "ключових модулів проєкту",
    "proof.security": "політики доступу за власником",
    "proof.mobile": "Flutter-first робочий процес",
    "mock.projects": "Мої проєкти",
    "mock.stage1": "У виконанні",
    "mock.stage2": "Підготовка",
    "mock.stage3": "Готово",
    "mock.projectType": "Житловий комплекс",
    "mock.projectName": "North Gate A12",
    "mock.badge": "На об'єкті",
    "mock.budget": "Бюджет",
    "mock.deadline": "Термін",
    "mock.schedule": "Стан графіка",
    "ops.title": "Жива панель проєкту",
    "ops.event1": "Критична затримка позначена як компенсована",
    "ops.event2": "Завантажено нове фото прогресу покрівлі",
    "ops.event3": "Сума бюджету перерахована тригером",
    "platform.eyebrow": "Що охоплює застосунок",
    "platform.title": "Повний контур від будмайданчика до офісу.",
    "platform.text": "Кожен модуль відповідає реальному робочому процесу, який уже присутній у Flutter-застосунку.",
    "features.projects.title": "Портфель проєктів",
    "features.projects.text": "Створюйте будівельні об'єкти, зберігайте адреси, типи, відповідальних осіб та статуси етапів від підготовки до завершення.",
    "features.budget.title": "Контроль бюджету",
    "features.budget.text": "Ведіть статті бюджету, описи та суми, а тригери бази даних підтримуватимуть підсумок проєкту актуальним.",
    "features.schedule.title": "Графік та затримки",
    "features.schedule.text": "Керуйте термінами, виконанням та затримками з ознаками поважності, компенсації, збігу та критичності.",
    "features.responsibility.title": "Матриця відповідальності",
    "features.responsibility.text": "Призначайте завдання на email відповідальних, відстежуйте відкритий або вирішений статус та тримайте зони відповідальності на виду.",
    "features.photos.title": "Фотофіксація",
    "features.photos.text": "Завантажуйте фото об'єкта в Supabase Storage, додавайте описи та переглядайте прогрес у компактній галереї.",
    "features.map.title": "Контекст на карті",
    "features.map.text": "Зберігайте адреси на карті та дивіться контекст розташування об'єкта на екранах з OpenStreetMap.",
    "workflow.eyebrow": "Створено для впровадження",
    "workflow.title": "Процес, який команда на об'єкті дійсно зможе підтримувати.",
    "workflow.step1.title": "Підключіть Supabase",
    "workflow.step1.text": "Вставте Project URL та anon key у налаштуваннях застосунку. Авторизація та сховище будуть готові для команди.",
    "workflow.step2.title": "Створіть проєкт",
    "workflow.step2.text": "Додайте назву, адресу, тип, етап, власника та відповідальних. Потім відкрийте робочий простір об'єкта.",
    "workflow.step3.title": "Ведіть щоденний контроль",
    "workflow.step3.text": "Оновлюйте бюджет, графік, відповідальність, затримки, фото та нотатки карти з одного екрана проєкту.",
    "supabase.eyebrow": "Підвкладка розгортання",
    "supabase.title": "Інструкція з розгортання бази Supabase.",
    "supabase.text": "Дотримуйтеся чеклиста, щоб розгорнути таблиці, політики, тригери, сховище та тестові дані для ConstructManager.",
    "tabs.dashboard": "Dashboard",
    "tabs.sql": "SQL-файли",
    "tabs.verify": "Перевірка",
    "deploy.create.title": "Створіть проєкт Supabase",
    "deploy.create.text": "Відкрийте Supabase, виберіть New project, задайте надійний пароль бази даних та найближчий регіон.",
    "deploy.sql.title": "Розгорніть схему бази даних",
    "deploy.sql.text": "Перейдіть на вкладку SQL files, відкрийте deploy.sql, скопіюйте весь вміст та виконайте в Supabase SQL Editor. Це створить усі таблиці, політики безпеки, правила сховища та тригери.",
    "deploy.auth.title": "Увімкніть Email-автентифікацію",
    "deploy.auth.text": "Перейдіть в Authentication → Providers та увімкніть Email. Додайте Site URL та Redirect URLs, якщо використовується OAuth.",
    "deploy.keys.title": "Скопіюйте API-ключі",
    "deploy.keys.text": "Перейдіть у Project Settings (іконка шестерні внизу зліва) → вкладка Data API в дашборді Supabase. Скопіюйте Project URL (вгорі сторінки — це НЕ адреса браузера, виглядає як https://<project-ref>.supabase.co; якщо є /rest/v1 в кінці — видаліть) та anon public key (у розділі Project API keys, починається з eyJ). Вставте їх у налаштування ConstructManager.",
    "sql.recommended.title": "Рекомендується: розгорнути все одразу",
    "sql.recommended.text": "Цей один файл містить всю базу даних. Відкрийте Supabase SQL Editor, створіть новий запит, вставте весь вміст нижче та натисніть Run.",
    "sql.manual.title": "Ручний порядок для налагодження",
    "sql.file1": "таблиці та індекси",
    "sql.file2": "політики Row Level Security",
    "sql.file3": "bucket для фото та політики",
    "sql.file4": "тригери та допоміжні функції",
    "sql.file5": "опціональні демодані",
    "sql.deploy": "схема + RLS + storage + функції",
    "verify.storage.title": "Storage bucket",
    "verify.storage.text": "Переконайтеся, що публічний bucket construction-photos існує в Storage.",
    "verify.realtime.title": "Опціональний realtime",
    "verify.realtime.text": "Увімкніть realtime для constructions, budgets та schedules, якщо потрібна жива синхронізація.",
    "verify.query.title": "Запустіть перевірочні запити",
    "verify.trouble.title": "Усунення проблем",
    "verify.trouble1": "Скрипт уже виконувався; продовжуйте, якщо схема бази коректна.",
    "verify.trouble2": "Перевірте, що 002-rls.sql виконано та поточний користувач володіє рядками проєкту.",
    "verify.trouble3": "Спочатку створіть відповідних auth.users або не запускайте 005-seed.sql у production.",
    "footer.supabase": "Інструкція Supabase",
    "footer.home": "Головна",
    "footer.back": "Вгору"
  }
};

const supportedLanguages = Object.keys(translations);
const languageButtons = document.querySelectorAll(".lang-button");
const translatableNodes = document.querySelectorAll("[data-i18n]");

function detectLanguage() {
  const savedLanguage = localStorage.getItem("constructmanager-language");
  if (supportedLanguages.includes(savedLanguage)) return savedLanguage;

  const browserLanguages = navigator.languages?.length ? navigator.languages : [navigator.language];
  const matched = browserLanguages
    .map((language) => language.toLowerCase().slice(0, 2))
    .find((language) => supportedLanguages.includes(language));

  return matched || "en";
}

function setLanguage(language, persist = true) {
  const activeLanguage = supportedLanguages.includes(language) ? language : "en";
  const dictionary = translations[activeLanguage];

  translatableNodes.forEach((node) => {
    const key = node.dataset.i18n;
    if (dictionary[key]) node.textContent = dictionary[key];
  });

  document.documentElement.lang = activeLanguage;
  document.title = activeLanguage === "ru"
    ? "ConstructManager — управление строительством"
    : activeLanguage === "uk"
      ? "ConstructManager — управління будівництвом"
      : activeLanguage === "de"
        ? "ConstructManager — Bauprojektmanagement"
        : "ConstructManager — construction project management";

  languageButtons.forEach((button) => {
    const isActive = button.dataset.lang === activeLanguage;
    button.classList.toggle("active", isActive);
    button.setAttribute("aria-pressed", String(isActive));
  });

  if (persist) localStorage.setItem("constructmanager-language", activeLanguage);
}

languageButtons.forEach((button) => {
  button.addEventListener("click", () => setLanguage(button.dataset.lang));
});

document.querySelectorAll(".tab").forEach((tab) => {
  tab.addEventListener("click", () => {
    const tabName = tab.dataset.tab;

    document.querySelectorAll(".tab").forEach((item) => {
      const isActive = item === tab;
      item.classList.toggle("active", isActive);
      item.setAttribute("aria-selected", String(isActive));
    });

    document.querySelectorAll(".tab-panel").forEach((panel) => {
      const isActive = panel.id === `tab-${tabName}`;
      panel.classList.toggle("active", isActive);
      panel.hidden = !isActive;
    });
  });
});

const sqlContents = {
  "database/deploy.sql": `-- ============================================================
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

SELECT 'ConstructManager database deployed successfully!' as result;`,
  "001-schema.sql": `-- ============================================================
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
CREATE INDEX IF NOT EXISTS idx_photos_uid ON photos(uid);`,

  "002-rls.sql": `-- ============================================================
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
    );`,

  "003-storage.sql": `-- ============================================================
-- ConstructManager — Supabase Storage Setup
-- Run after 002-rls.sql
-- 1. Create bucket manually in Supabase Dashboard OR via API
-- 2. Run this SQL for bucket policies
-- ============================================================

-- Ensure the bucket exists (run CREATE or use Dashboard)
-- INSERT INTO storage.buckets (id, name, public)
-- VALUES ('construction-photos', 'construction-photos', true)
-- ON CONFLICT (id) DO NOTHING;

-- ******************** STORAGE POLICIES ********************

-- Allow authenticated users to upload photos
CREATE POLICY "authenticated_upload_photos"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'construction-photos'
);

-- Allow public access to view photos
CREATE POLICY "public_view_photos"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'construction-photos');

-- Allow authenticated users to update photos
CREATE POLICY "authenticated_update_photos"
ON storage.objects
FOR UPDATE
TO authenticated
USING (bucket_id = 'construction-photos');

-- Allow authenticated users to delete their photos
CREATE POLICY "authenticated_delete_photos"
ON storage.objects
FOR DELETE
TO authenticated
USING (bucket_id = 'construction-photos');

-- ******************** VERIFICATION ********************
SELECT
    'Storage policies created' as status,
    COUNT(*) as policy_count
FROM pg_policies
WHERE tablename = 'objects'
AND schemaname = 'storage';`,

  "004-functions.sql": `-- ============================================================
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
SELECT 'Functions and triggers created successfully' as status;`,

  "005-seed.sql": `-- ============================================================
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
ON CONFLICT (uid) DO NOTHING;`
};

document.querySelectorAll(".file-item").forEach((button) => {
  button.addEventListener("click", () => {
    const filename = button.dataset.sqlFile;
    const pre = button.nextElementSibling;
    const code = pre.querySelector("code");
    const isOpen = button.getAttribute("aria-expanded") === "true";

    if (isOpen) {
      button.setAttribute("aria-expanded", "false");
      pre.hidden = true;
      return;
    }

    if (!code.dataset.loaded) {
      code.textContent = sqlContents[filename] || `File ${filename} not found`;
      code.dataset.loaded = "true";
    }

    button.setAttribute("aria-expanded", "true");
    pre.hidden = false;
  });
});

setLanguage(detectLanguage(), false);
