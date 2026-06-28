# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Flutter mobile/web ERP for Indian jewellery shops. The primary business entity is **Girvi** (gold pledge/pawn loan). The app runs fully offline against a local mock backend; no real server exists yet.

## Commands

```bash
flutter pub get                                          # install deps
flutter analyze                                         # lint (uses flutter_lints)
flutter test                                            # run all tests
flutter test test/widget_test.dart                      # run a single test file
flutter run                                             # run on connected device
flutter build apk --debug                               # debug APK
flutter build apk --release                             # release APK
flutter build web --no-tree-shake-icons --release       # web build (deployed to Cloudflare Pages)
dart run build_runner build --delete-conflicting-outputs  # regenerate code after changing injectable, freezed, or json_serializable annotations
```

CI runs `flutter analyze --no-fatal-infos --no-fatal-warnings` and builds both APK variants on every push to `main`/`master`. Web is deployed to Cloudflare Pages on push to `main`.

## Architecture

### Layered clean architecture per feature

Every feature under `lib/src/features/<name>/` has the same shape:

```
domain/
  entities/         # pure Dart, extends Equatable — no serialization
  repositories/     # abstract interface
data/
  models/           # extends entity with fromJson/toJson (json_serializable/freezed)
  repositories/     # @LazySingleton(as: XRepository) implements XRepository
presentation/
  bloc/             # BLoC: *_bloc.dart, *_event.dart, *_state.dart
pages/              # full-screen widgets; obtain BLoC via BlocProvider.of or context.read
widgets/            # feature-scoped reusable widgets
theme/              # feature-specific color constants (*_colors.dart)
<feature>.dart      # barrel export
```

### Dependency injection

`injectable` + `get_it`. `@injectable`, `@lazySingleton`, `@singleton`, and `@factory` annotations drive codegen. The generated file is `lib/src/core/di/injection.config.dart` — **do not edit it by hand**. External dependencies (SharedPreferences, FlutterSecureStorage) are provided in `lib/src/core/di/register_module.dart`.

All BLoCs and repositories are resolved through `getIt`. The root `main.dart` calls `configureDependencies()` before `runApp`.

### Mock backend

`ApiClient` (`lib/src/core/api/api_client.dart`) wraps Dio and attaches `MockInterceptor`. **All API calls currently resolve locally** — `MockInterceptor` (`lib/src/core/api/interceptors/mock_interceptor.dart`) intercepts every request and returns hardcoded data. When a real backend is available: remove the `MockInterceptor` from `_buildDio()` and update `baseUrl`.

All endpoints are declared as string constants in `ApiEndpoints` (`lib/src/core/api/api_endpoints.dart`).

### Result type

Repositories return `Result<T>` — a sealed class with `Success<T>` and `Failure<T>`. Use `.when(success: ..., failure: ...)`. `AppException` subtypes: `NetworkException`, `AuthException`, `ServerException`, `NotFoundException`.

### Routing

`go_router` with a single `appRouter` instance (`lib/src/app/app_router.dart`). All routes are named constants (`PageClass.routeName`). Complex data is passed via `state.extra`; cast it immediately in the builder. Route guards are not yet wired — auth redirects are handled by `AuthBloc` watching state.

### State management

`flutter_bloc`. `AuthBloc` is a **lazySingleton** provided at the app root in `JewelleryErpApp`. Feature BLoCs are **factories** (new instance per screen) and should be provided with `BlocProvider` in the owning page widget.

### Localisation

Custom hand-rolled localisation — **no `flutter_localizations` or `.arb` files**. The system:
- `AppL10n` (`lib/src/core/l10n/app_l10n.dart`) — abstract class with English, Marathi, Hindi implementations
- `AppLanguageNotifier` — `ValueNotifier<AppLanguage>` holding the active language
- `AppLangProvider` — `InheritedWidget` scoped to the entire app; read with `context.dependOnInheritedWidgetOfExactType<AppLangProvider>()`
- `BilingualText` widget — renders native-script text with a small English subtitle below; `compact: true` for tight spaces (chips/badges)

To add a new string: add a getter to `AppL10n` and implement it in all three language classes.

### Theme

Defined globally in `JewelleryErpApp`. Colour palette in `AppColors` (`lib/src/core/theme/app_colors.dart`): `navy` is the primary colour, `gold` is the accent. Each feature also has a `*_colors.dart` for feature-specific shades. Material 3 is enabled. Responsive breakpoints: MOBILE < 600, TABLET 600–1023, DESKTOP 1024–1439, 4K 1440+.

### Storage

- `SecureStorage` — wraps `FlutterSecureStorage`; used for tokens/session
- `PrefsStorage` — wraps `SharedPreferences`; used for user preferences and language setting

## Key domain concepts

| Term | Meaning |
|------|---------|
| Girvi | Gold pledge / pawn loan. Core business object. Status lifecycle: `active → partialPaid / renewed / redeemed / overdue` |
| Katmiti | Traditional Indian diminishing-balance interest method (one of three `InterestType` values alongside `simple` and `daily`) |
| KFS | Key Fact Statement — RBI-mandated disclosure document for each girvi |
| Vault coordinate | Physical location string: `VA-A/SF-02/TR-05/SL-18` (Vault/Safe/Tray/Slot) |
| LTV | Loan-to-Value ratio; RBI cap is 85% for gold loans |
| Form 6/9/11/12/13 | Regulatory compliance forms required by Indian law for pawnbrokers |
| Tenant | Multi-tenant concept; every record carries `tenantId` |

All monetary amounts are in INR. GST on gold sales is 3% (split as 1.5% CGST + 1.5% SGST).

## Code generation

Files excluded from analysis (`analysis_options.yaml`): `**/*.g.dart`, `**/*.freezed.dart`. Run `dart run build_runner build --delete-conflicting-outputs` after any change to:
- `@injectable`/`@lazySingleton`/`@singleton`/`@factory` annotations (updates `injection.config.dart`)
- `@JsonSerializable` annotations on models (updates `*.g.dart`)
- `@freezed` annotations (updates `*.freezed.dart`)

## Linting rules (beyond flutter_lints defaults)

- `prefer_single_quotes: true`
- `sort_child_properties_last: true`
