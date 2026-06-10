# Drift Migration Progress

## Documentation Decisions

- [x] Record local Supabase development database URL for schema/tooling use.
- [x] Clarify that Supabase remains the authoritative remote Postgres schema.
- [x] Clarify that Drift locally mirrors table/column contracts where practical, not Postgres-only behavior.
- [x] Add abstract Drift DAO/base class guidance.
- [x] Clarify that the abstract base should share logging/guard behavior, not hide all typed Drift queries behind generic CRUD.
- [x] Document card-template polymorphism strategy.
- [x] Document that RLS remains Supabase-only and local Drift does not enforce it.
- [x] Document that Drift-to-Supabase writes still need table-specific mappers.

## Open Architecture Work

- [ ] Scaffold `packages/boo_mondai_db`.
- [ ] Scaffold `packages/boo_mondai_migrations`.
- [ ] Add Drift modular `build.yaml`.
- [ ] Add app dependency on `boo_mondai_db`.
- [ ] Add app-level Drift connection using `drift_flutter`.
- [ ] Add an in-memory database smoke test.
- [ ] Define `AppDriftDao` base class.
- [ ] Decide exact exception type/mapping for Drift DAO guards.
- [ ] Decide whether sync metadata is embedded in each table or stored in sidecar tables.

## Card Template Work

- [ ] Define local Drift `card_templates` table matching Supabase columns.
- [ ] Define local Drift child tables for `multiple_choice_options`, `fill_in_the_blank_segments`, `match_madness_pairs`, and `card_template_tags`.
- [ ] Add enum converter for card template `type`.
- [ ] Add enum converter for `card_type`.
- [ ] Add JSON converter for `design_config`.
- [ ] Build `CardTemplatesDao` typed queries.
- [ ] Build joined query for template plus tags/options/segments/pairs.
- [ ] Add `CardTemplateAssembler` or equivalent joined-row-to-domain mapper.
- [ ] Add companion builders for writing each template subtype to Drift.
- [ ] Add sync mapper from Drift rows to Supabase parent/child payloads.

## Sync Work

- [ ] Replace generic `SyncService<T extends DTO>` for the first migrated table group.
- [ ] Add table-specific pull from Supabase into Drift companions.
- [ ] Add table-specific push from dirty Drift rows to Supabase maps.
- [ ] Handle Supabase RLS failures during push.
- [ ] Add tests for dirty, synced, deleted, and failed sync states.

## Verification

- [ ] Run `flutter pub get`.
- [ ] Run `dart run build_runner build --delete-conflicting-outputs`.
- [ ] Run `dart format lib test packages`.
- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Run package-level `dart test` in `packages/boo_mondai_db`.
- [ ] Generate Drift schema snapshots.
