# Delivery Plan for Upcoming Iterations

## Workflow Expectations
- Work through phases sequentially; do not overlap tasks across phases.
- After finishing any numbered task list, run required checks, update `progress.md`, then execute `git add .` and a descriptive `git commit`.
- Keep branches focused per phase when possible; rebase on main before each pull request.
- Prefer small, cohesive files; split large widgets, services, or views into focused modules to ease maintenance.

## Phase 1 — Profile Screen UI
1. Add navigation entry point (tab or icon) and scaffold read-only profile view using current mock data.
2. Implement edit mode with validation, photo gallery carousel, and optimistic persistence stub.
3. Wire profile updates to interim local storage helper and add UI tests for validation messaging.
4. Update documentation (`AGENTS.md`) and `progress.md` with outcomes and blockers.

## Phase 2 — Chat Redesign
1. Audit existing chat page to catalogue components slated for replacement.
2. Implement Tinder-style app bar, match banner, and bubble styling; confirm accessibility contrast.
3. Refresh composer layout and add message metadata (timestamps, avatars).
4. Run widget tests or golden tests to guard layout, then document learnings in `progress.md`.

## Phase 3 — Settings Bottom Sheet
1. Create reusable settings controller/service backed by `SharedPreferences`.
2. Build modal bottom sheet with discovery controls, location stub, and reset defaults.
3. Integrate triggers from Discover and Profile screens; ensure state sync across sessions.
4. Add tests for preference serialization and update `progress.md`.

## Phase 4 — Domain Models
1. Introduce `lib/models/` and define profile, preference, match, conversation, and message classes with JSON helpers.
2. Replace inline mock data with repository classes and model instances.
3. Run analyzer/tests, update docs, and commit.

## Phase 5 — FastAPI Mock Backend
1. Scaffold `/server` FastAPI project with data schemas mirroring Dart models.
2. Implement read/write endpoints and load deterministic seed data.
3. Add README instructions, sample `.env`, and smoke tests (pytest or curl script).
4. Connect Flutter app to consume HTTP layer using repositories; add integration toggle for offline mode.

## Testing & Quality Gates
- Minimum checks per phase: `dart format .`, `flutter analyze`, `flutter test`, plus backend lint/tests when applicable.
- Document any skipped tests or TODOs in `progress.md` to maintain traceability.
- Coordinate PR reviews with screenshots or screen recordings for UI-heavy phases.
