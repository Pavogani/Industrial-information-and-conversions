## Purpose

This file gives focused, actionable guidance for AI coding agents working in this Flutter repository so they can be immediately productive.

## Big picture
- Flutter mobile app with platform folders (`android/`, `ios/`) and a single app entry at `lib/main.dart`.
- State management: `flutter_riverpod` (see `lib/main.dart` for `ProviderScope`).
- Navigation: `go_router` configured in `lib/core/router/app_router.dart`.
- Feature-focused layout: domain folders under `lib/features/` (e.g., `calculators`, `converters`, `fasteners`, `reference`, `rigging`, `welding`).
- Core shared code: `lib/core/` holds `models/`, `providers/`, `router/`, and `services/` — use these for cross-cutting changes.

## Data & integration points
- Local storage: `sqflite` + `path_provider` (see `pubspec.yaml`). Expect DB access in `lib/core/services` or feature services.
- Native integration: Android Gradle wrapper present at `android/gradlew.bat` and `android/gradlew`; iOS project under `ios/Runner`.

## Build / test / debug workflows (explicit)
- Get deps: `flutter pub get`.
- Run locally: `flutter run -d <device>` (or use IDE). On Windows use attached Android emulator or physical device.
- Build APK: `flutter build apk` (or use `android/gradlew.bat` for Gradle tasks on Windows).
- Build iOS: `flutter build ios` (requires macOS and Xcode).
- Tests: `flutter test` runs `test/widget_test.dart`.
- Common CI-friendly commands: `flutter analyze` and `flutter test`.

Notes for agents: when referencing Gradle tasks on Windows use `android\gradlew.bat` (workspace contains `gradlew.bat`).

## Project-specific conventions
- Feature-first organization: prefer adding new screens and logic under `lib/features/<domain>/` rather than scattering across `core`.
- Providers live under `lib/core/providers` and are composed into widgets via Riverpod patterns (look for `Provider`/`StateNotifier` usages).
- Router centralization: add routes in `lib/core/router/app_router.dart` and register pages under feature folders.
- Services that access storage or other resources belong in `lib/core/services` and are injected via providers.
- UI theming: Material 3 theming via `ThemeData` seeds in `lib/main.dart`; keep dark/light parity.

## Examples (where to look)
- App entry / Provider scope: [lib/main.dart](lib/main.dart#L1-L40)
- Router config: [lib/core/router/app_router.dart](lib/core/router/app_router.dart)
- Dependencies & plugins: [pubspec.yaml](pubspec.yaml#L1-L120)
- Feature layout: [lib/features](lib/features)

## Editing guidance for AI agents
- Make minimal, focused edits. Follow the feature-first layout and add new providers/services under `lib/core` or `lib/features/<domain>/`.
- When adding dependencies, update `pubspec.yaml` and run `flutter pub get`. Prefer exact versions present in the repo when available.
- For navigation changes, update `app_router.dart` and add corresponding screen widgets in the feature folder.
- Don't modify platform build files (`android/*`, `ios/*`) unless addressing a specific native integration; prefer adding configuration via Flutter build flags when possible.

## Merging with existing guidance
- If other AI-guidance files exist, preserve any project-specific rules they contain (branching, commit messages, or CI details). Merge their unique constraints into this file.

## When to ask the human
- If a task needs new platform signing keys, Play/App Store configs, or macOS/iOS builds — request credentials or a macOS environment.
- If the change affects project-wide state shape (DB schema changes under `lib/core/services`), ask for migration guidance or acceptance criteria.

---
If any section is unclear or you want more examples (tests, common provider patterns, or CI steps), tell me which area to expand.
