# Repository Guidelines

## Project Structure & Module Organization

This is a Flutter app for BooMondai, a gamified language-learning system with FSRS spaced repetition and Supabase sync. Core Dart code lives in `lib/`: app setup in `main.dart` and `app.dart`, feature screens in `pages/`, reusable UI in `widgets/`, state/business logic in `controllers/` and `services/`, persistence in `database/` and `hive/`, and serializable domain objects in `models/`. Platform targets are under `android/`, `ios/`, `linux/`, `macos/`, `web/`, and `windows/`. Tests live in `test/`. Supabase schema, migrations, and reference context live in `supabase/`; design and architecture notes live in `documentation/` and `references/`.

## Build, Test, and Development Commands

- `flutter pub get` installs Dart and Flutter dependencies.
- `dart run build_runner build --delete-conflicting-outputs` regenerates mapper, Hive, and barrel files after model or export changes.
- `dart format lib test` formats Dart sources.
- `flutter analyze` runs static analysis with `flutter_lints`.
- `flutter test` runs the widget/unit test suite.
- `flutter run -d chrome` runs the web target locally; choose another device id for mobile or desktop.

## Coding Style & Naming Conventions

Use standard Dart formatting: two-space indentation, trailing commas for readable multiline Flutter trees, and analyzer-clean code. File names are `snake_case.dart`; classes, enums, and widgets use `PascalCase`; methods, variables, and providers use `lowerCamelCase`. Keep feature-specific widgets in their existing `lib/widgets/<feature>/` folders and shared components in `lib/widgets/`. Generated files such as `*.mapper.dart`, `*.barrel.dart`, and Hive registrar/adapters should be regenerated, not hand-edited.

## Testing Guidelines

Use `flutter_test` for widget and unit coverage, with Mockito available for mocks. Add tests under `test/` using `*_test.dart` names, mirroring the source area where practical. For user-facing changes, cover the main interaction path and failure state. Run `flutter test` and `flutter analyze` before submitting changes.

## Commit & Pull Request Guidelines

Recent history uses Conventional Commit style, for example `fix(hive): register deck browser adapters` and `docs(context): refresh project handoff`. Keep commits scoped and imperative: `feat(models): add deck browser DTOs`, `refactor(controllers): use repository API`. Pull requests should include a short summary, linked issue or task, test results, and screenshots or recordings for visible UI changes. Mention schema or migration impacts when touching `supabase/`.

## Security & Configuration Tips

Do not commit local secrets, Supabase keys, or generated environment files. Keep database changes in timestamped `supabase/migrations/` files and update `supabase/schema_reference.sql` or context docs when the schema contract changes.
