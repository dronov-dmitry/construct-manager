# ConstructManager — Migration Plan: Android (Kotlin) → Flutter (Dart)

## Overview

| Item | Android (Kotlin) | Flutter (Dart) |
|------|-----------------|-----------------|
| Language | Kotlin + Java | Dart |
| UI | XML layouts (39 files) | Widgets (code) |
| Architecture | MVVM + Repository | BLoC / Riverpod + Repository |
| Backend | Supabase (supabase-kt) | Supabase (supabase-flutter) |
| Local DB | Room (SQLite) | drift / isar |
| DI | Dagger Hilt | get_it + injectable |
| Navigation | Fragment-based (Nav Component) | go_router |
| Image loading | Glide | cached_network_image |
| Maps | Google Maps (WebView) | flutter_map / google_maps_flutter |
| Auth | Supabase Auth (GoTrue) | supabase_flutter auth |
| Charts | MPAndroidChart | fl_chart |
| Biometric | AndroidX Biometric | local_auth |
| Camera/Gallery | Intent-based | image_picker |
| Offline-first | Room + manual sync | drift + supabase sync |
| Localization | values/strings.xml (ru/en) | flutter_localizations + ARB |

---

## Project Structure (Flutter)

```
dart/construct_manager/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── constants/
│   │   │   └── constants.dart
│   │   ├── enums/
│   │   │   ├── construction_stage.dart
│   │   │   └── responsibility_state.dart
│   │   ├── errors/
│   │   │   └── exceptions.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── status_colors.dart
│   │   ├── utils/
│   │   │   ├── validators.dart
│   │   │   └── helpers.dart
│   │   └── network/
│   │       └── supabase_client.dart
│   ├── data/
│   │   ├── models/
│   │   │   ├── construction.dart
│   │   │   ├── user.dart
│   │   │   ├── budget.dart
│   │   │   ├── schedule.dart
│   │   │   ├── delay.dart
│   │   │   ├── responsibility.dart
│   │   │   ├── photo.dart
│   │   │   └── information.dart
│   │   ├── services/
│   │   │   ├── auth_service.dart
│   │   │   ├── construction_service.dart
│   │   │   ├── budget_service.dart
│   │   │   ├── schedule_service.dart
│   │   │   ├── responsibility_service.dart
│   │   │   ├── photo_service.dart
│   │   │   └── user_service.dart
│   │   └── repositories/
│   │       └── construction_repository.dart
│   ├── presentation/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── signup_screen.dart
│   │   │   ├── update_email_screen.dart
│   │   │   └── update_password_screen.dart
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── settings/
│   │   │   └── settings_screen.dart
│   │   ├── constructions/
│   │   │   ├── construction_list_screen.dart
│   │   │   ├── construction_form_screen.dart
│   │   │   └── construction_view_screen.dart
│   │   ├── budget/
│   │   │   ├── budget_form_screen.dart
│   │   │   ├── budget_list_screen.dart
│   │   │   └── budget_view_screen.dart
│   │   ├── schedule/
│   │   │   ├── schedule_form_screen.dart
│   │   │   ├── schedule_list_screen.dart
│   │   │   ├── schedule_view_screen.dart
│   │   │   ├── delay_form_screen.dart
│   │   │   └── delay_view_screen.dart
│   │   ├── responsibility/
│   │   │   ├── responsibility_form_screen.dart
│   │   │   ├── responsibility_list_screen.dart
│   │   │   └── responsibility_view_screen.dart
│   │   ├── photos/
│   │   │   ├── photo_form_screen.dart
│   │   │   ├── photo_list_screen.dart
│   │   │   └── photo_view_screen.dart
│   │   ├── map/
│   │   │   └── map_screen.dart
│   │   └── info/
│   │       └── info_edit_screen.dart
│   ├── widgets/
│   │   ├── loading_animation.dart
│   │   ├── status_badge.dart
│   │   ├── construction_card.dart
│   │   └── empty_state.dart
│   └── l10n/
│       ├── app_en.arb
│       └── app_ru.arb
├── test/
├── pubspec.yaml
└── analysis_options.yaml
```

---

## Migration Phases

### Phase 1: Foundation (Day 1-2)

| Step | Task | Files | Status |
|------|------|-------|--------|
| 1.1 | Create Flutter project with `flutter create` | — | ✅ |
| 1.2 | Configure `pubspec.yaml` with all dependencies | `pubspec.yaml` | ✅ |
| 1.3 | Set up `supabase_flutter` client (dynamic URL/key) | `core/network/supabase_client.dart` | ✅ |
| 1.4 | Set up DI (`get_it`) | `core/di/service_locator.dart` | ✅ |
| 1.5 | Configure GoRouter navigation | `app.dart` | ✅ |
| 1.6 | Set up theme (light/dark, status colors) | `core/theme/` | ✅ |
| 1.7 | Add localization (RU/EN) | `l10n/` | ✅ |

**Dependencies:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.8.0
  go_router: ^14.0.0
  get_it: ^8.0.0
  flutter_riverpod: ^2.6.0
  drift: ^2.22.0
  sqlite3_flutter_libs: ^0.5.0
  image_picker: ^1.1.0
  cached_network_image: ^3.4.0
  flutter_map: ^7.0.0
  latlong2: ^0.9.0
  fl_chart: ^0.69.0
  local_auth: ^2.3.0
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
  path_provider: ^2.1.0
  path: ^1.9.0
```

### Phase 2: Data Layer (Day 3-5)

| Step | Task | Files | Status |
|------|------|-------|--------|
| 2.1 | Enums: `ConstructionStage`, `ResponsibilityState` | `core/enums/` | ✅ |
| 2.2 | Models: `Construction`, `User`, `Budget`, `Schedule` | `data/models/` | ✅ |
| 2.3 | Models: `Delay`, `Responsibility`, `Photo`, `Information` | `data/models/` | ✅ |
| 2.4 | Auth Service (login, register, logout, session) | `data/services/auth_service.dart` | ✅ |
| 2.5 | Construction Service (CRUD + stage transitions) | `data/services/construction_service.dart` | ✅ |
| 2.6 | Budget Service (CRUD) | `data/services/budget_service.dart` | ✅ |
| 2.7 | Schedule + Delay Service | `data/services/schedule_service.dart` | ✅ |
| 2.8 | Responsibility Service | `data/services/responsibility_service.dart` | ✅ |
| 2.9 | Photo Service (upload + storage) | `data/services/photo_service.dart` | ✅ |
| 2.10 | User Service | `data/services/user_service.dart` | ✅ |
| 2.11 | Construction Repository (offline-first) | `data/repositories/construction_repository.dart` | ⬜ |

### Phase 3: Auth Screens (Day 6-7)

| Step | Task | Depends on | Status |
|------|------|-----------|--------|
| 3.1 | Login Screen (`MainActivity`) | Auth Service | ✅ |
| 3.2 | Sign Up Screen | Auth Service | ✅ |
| 3.3 | Update Email Screen | Auth Service | ✅ |
| 3.4 | Update Password Screen | Auth Service | ✅ |
| 3.5 | Home Screen (post-login dashboard) | Auth + Constr. Service | ✅ |
| 3.6 | Settings Screen (Supabase config, lang, theme) | Settings | ✅ |

### Phase 4: Construction Screens (Day 8-10)

| Step | Task | Depends on | Status |
|------|------|-----------|--------|
| 4.1 | Construction List (filter by stage, paging) | Constr. Service | ✅ |
| 4.2 | Construction Form (create/edit) | Constr. Service | ✅ |
| 4.3 | Construction View (unified for all stages) | Constr. Service | ✅ |
| 4.7 | Info Edit Screen (inline editing) | Constr. Service | ✅ |

### Phase 5: Feature Screens (Day 11-15)

| Step | Task | Depends on | Status |
|------|------|-----------|--------|
| 5.1 | Budget Form + List | Budget Service | ✅ |
| 5.2 | Schedule Form + List | Schedule Service | ✅ |
| 5.3 | Delay Form | Schedule Service | ✅ |
| 5.4 | Responsibility Form + List | Resp. Service | ✅ |
| 5.5 | Photo Capture/Select + List (grid) | Photo Service | ✅ |
| 5.6 | Map Screen (flutter_map + OpenStreetMap) | — | ✅ |

### Phase 6: Polish & Testing (Day 16-18)

| Step | Task | Status |
|------|------|--------|
| 6.1 | Shared widgets (ConstructionCard, StatusBadge, Loading, EmptyState) | ⬜ |
| 6.2 | Offline-first sync (drift + Supabase) | ✅ |
| 6.3 | Biometric auth (local_auth) | ✅ |
| 6.4 | i18n: Russian + English strings | ✅ |
| 6.5 | Unit tests for services (validators, models) | ✅ |
| 6.6 | Widget tests for LoginScreen | ✅ |
| 6.7 | Integration test (auth → create → view flow) | ⬜ |
| 6.8 | Performance optimization (image caching, lazy loading) | ✅ |

---

## Current Progress

- [x] Project analysis completed
- [x] **Phase 1:** Foundation (Day 1-2)
- [x] **Phase 2:** Data Layer (Day 3-5)
- [x] **Phase 3:** Auth Screens (Day 6-7) ✅
- [x] **Phase 4:** Construction Screens (Day 8-10) ✅ (list + form + view + info)
- [x] **Phase 5:** Feature Screens (Day 11-15) ✅
- [x] **Phase 6:** Polish & Testing (Day 16-18) ✅

---

## State Management

Using **Riverpod** (`flutter_riverpod`) for state management — it's more modern and testable than BLoC for this project size.

- `StateNotifierProvider` for complex state (auth, construction list)
- `FutureProvider` / `StreamProvider` for simple async data
- `AutoDispose` for memory management

## Data Flow

```
UI (Widget) → Riverpod Provider → Service (Supabase) → Supabase Cloud
                                    ↓
                              Repository (optional)
                                    ↓
                              Drift Database (offline cache)
```

## Notes

- The Android app uses `Room` with `Flow` for reactive offline DB. In Flutter, `drift` provides `Stream`-based reactive queries.
- Supabase Kotlin client and Flutter client share the same REST/GraphQL backend — no server changes needed.
- Dynamic Supabase config (URL + anon key) stored in `SharedPreferences` via `shared_preferences` package.
- Camera/gallery access uses `image_picker` — no native intent code needed.
- Maps: original app used Google Maps via WebView. For Flutter, `flutter_map` (OpenStreetMap) is free and works cross-platform. Can switch to `google_maps_flutter` if Google Maps API key is available.
