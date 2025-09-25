# Repository Guidelines

## Project Structure & Module Organization

The Flutter entrypoint lives in `lib/main.dart`, which wires navigation, chat UI, and any app-wide providers. UI widgets and services should be split into new files under `lib/` to keep `main.dart` lightweight. Platform scaffolding resides in `android/`, `ios/`, and `web/`; do not edit generated build outputs in `build/`. Shared media and configuration artifacts belong in `assets/`, and every addition must be declared in `pubspec.yaml` to ship with the app.

## Build, Test, and Development Commands

Run `flutter pub get` after dependency changes to refresh the lockfile. Use `flutter run` for an interactive debug session on a connected device or emulator. Execute `flutter analyze` to surface lint issues before submitting code. For production binaries use `flutter build apk` or the platform-specific `flutter build ios` flow.

## Coding Style & Naming Conventions

Adhere to Dart's idiomatic 2-space indentation and rely on `dart format .` (or the IDE formatter) to normalize whitespace. Enable trailing commas on multiline widget trees so the formatter keeps a predictable layout. Classes and enums use UpperCamelCase, methods and variables use lowerCamelCase, and filenames stay in snake_case. The repo inherits `flutter_lints` via `analysis_options.yaml`; fix or justify every warning rather than suppressing it.

## Testing Guidelines

Place all tests under a top-level `test/` directory that mirrors the `lib/` structure. Write widget and unit tests with `package:flutter_test/flutter_test.dart`, grouping related cases and naming each test with the scenario and expected outcome. Run `flutter test` locally before opening a pull request, and aim for coverage on new logic, especially chat interaction flows and asset loading.

## Commit & Pull Request Guidelines

Follow the existing history by keeping commit titles short and action-oriented, e.g., `Add chat message composer`. Squash experimental commits before pushing, and ensure the summary describes the user-facing change. Pull requests should include a concise description, call out affected screens, link any relevant issue IDs, and attach screenshots or screen recordings for UI updates. Confirm that `flutter analyze` and `flutter test` both pass before requesting review.
