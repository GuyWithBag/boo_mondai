# Repository Guidelines

## Project Structure & Module Organization

This is a Flutter/Dart app for BooMondai, a gamified language learning app with FSRS spaced repetition. App entry points live in `lib/main.dart`, `lib/app.dart`, and `lib/routes.dart`. Shared infrastructure is under `lib/core/` for database wrappers, hooks, helpers, theme, services, and reusable widgets. Feature code is organized by domain in `lib/features/<feature>/`, commonly with controllers, services, local/remote DB adapters, widgets, models, and `*.barrel.dart` exports. Tests mirror this split under `test/core/` and `test/features/`. Platform folders are `android/`, `ios/`, `web/`, `linux/`, `macos/`, and `windows/`. Supabase configuration, migrations, and seed data are in `supabase/`; design notes and reference material are in `context/`, `documentation/`, and `references/`. Font assets are in `fonts/`.

## Build, Test, and Development Commands

- `flutter pub get`: install Dart and Flutter dependencies.
- `flutter run`: run the app on the selected device or emulator.
- `flutter test`: run all widget and unit tests.
- `flutter analyze`: run static analysis using `analysis_options.yaml`.
- `dart format lib test`: format Dart source and tests.
- `dart run build_runner build --delete-conflicting-outputs`: regenerate mapper, Hive, and barrel outputs after model or annotation changes.
- `npx supabase migration list`: inspect local/remote Supabase migration state when working on schema changes.

## Coding Style & Naming Conventions

Follow `package:flutter_lints/flutter.yaml` and Dart's standard two-space formatting. Prefer feature-local files and exports over adding shared abstractions too early. Existing filenames use lower snake case with domain suffixes, such as `deck.sync_service.dart`, `study_session.controller.dart`, `deck.dto.dart`, and generated `*.mapper.dart`. Keep generated files generated; do not hand-edit mapper, Hive, or barrel outputs unless explicitly required.

## Testing Guidelines

Use `flutter_test` for unit and widget coverage. Place tests beside their domain in `test/core/...` or `test/features/...`, and name files with the `_test.dart` suffix. Add focused tests for helpers, controllers, search/filter behavior, persistence boundaries, and study-session logic. Run `flutter test` before submitting changes; run `flutter analyze` when touching public APIs, generated models, or platform-sensitive code.

## Commit & Pull Request Guidelines

Recent history uses Conventional Commit-style messages, for example `feat(media): ...`, `fix(layout): ...`, and `refactor(drill): ...`. Keep commits scoped and use an imperative summary. Pull requests should include a short description, test results, linked issue or context, screenshots for UI changes, and notes for schema migrations or generated-code updates.

## Security & Configuration Tips

Do not commit local secrets or generated Supabase temp files. Treat `supabase/.env.local` and `supabase/.temp/` as local state. When changing database behavior, update migrations and the matching local/remote DB adapters together.
