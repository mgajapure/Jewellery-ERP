# Jewellery ERP

A Flutter starter application for a Jewellery ERP product. The repository is initialized with a Material 3 app shell, dashboard, inventory route, state-management, networking, persistence, responsive layout, charting, image caching, localization utilities, and code-generation dependencies.

## Stack

- Flutter SDK: `>=3.35.0`
- Dart SDK: `>=3.9.0 <4.0.0`
- Routing: `go_router`
- State management: `flutter_riverpod`
- HTTP client: `dio`
- Local and secure persistence: `shared_preferences`, `flutter_secure_storage`
- UI helpers: `google_fonts`, `responsive_framework`, `cached_network_image`, `fl_chart`
- Serialization/code generation: `freezed`, `freezed_annotation`, `json_annotation`, `json_serializable`, `build_runner`
- Linting: `flutter_lints`

## Getting started

Install the latest stable Flutter SDK, then run:

```bash
flutter pub get
flutter test
flutter run
```

If platform runner folders are needed for a target platform, generate them with:

```bash
flutter create --platforms=android,ios,web,linux,macos,windows .
```

## Project structure

```text
lib/
  main.dart
  src/
    app/
    core/
      network/
      storage/
    features/
      dashboard/
      inventory/
test/
  widget_test.dart
```
