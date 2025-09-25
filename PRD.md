# Product Requirements Document: Gonder Next Iterations

## 1. Overview

The goal of this release train is to evolve Gonder from a swipe demo into a minimal matchmaking experience with editable user data, Tinder-style conversations, configurable discovery preferences, typed data models, and a mock FastAPI backend. Delivery is sequenced to build UI capabilities first, then wire them to real data sources.

## 2. Objectives & Success Metrics

- Deliver a polished profile management flow so users can view and edit their information without developer intervention.
- Modernize the chat experience to mirror core Tinder visuals and interaction patterns.
- Provide configurable discovery preferences through a settings bottom sheet that persists locally.
- Replace placeholder structures with strongly typed Dart models that align with backend payloads.
- Stand up a FastAPI mock server delivering consistent data for profiles, matches, and conversations.

Success metrics: zero critical UX bugs in dogfooding, all analyzer/test suites green, and mobile build passes using API responses only.

## 3. Scope & Phasing

Work must ship in the following order, committing after each phase:

1. Profile screen UI (view + edit)
2. Chat redesign to Tinder look & feel
3. Settings bottom sheet for discovery preferences
4. Dart domain models
5. FastAPI mock backend

Each phase closes with `git add .`, `git commit -m "<phase summary>"`, and updates to `progress.md`.

## 4. Personas & Use Cases

- **Primary user**: Dating app participant wanting to manage their profile, chat, and preferences.
- **Internal tester**: QA verifying flows using mock backend.
- **Developer agent**: Implements features while keeping files organized and progress documented.

## 5. Functional Requirements

### 5.1 Profile Screen UI

- Entry via new bottom-nav item or profile icon from existing layout.
- Screen displays avatar (primary photo), name, age, job title, bio, current city, gallery (horizontal scroll of photos), and editable discovery toggles (looking for, gender identity).
- Edit mode uses inline forms with validation: name (1-30 chars), age (18-99), bio (max 280 chars), city (non-empty), gallery (3-9 images from assets or file picker placeholder).
- Include save button, cancel/discard prompt, success toast/snackbar, and optimistic local persistence (`SharedPreferences` placeholder until backend wiring).

### 5.2 Chat Redesign

- Adopt layout inspired by provided screenshot: gradient header with match info, bold name, match date, alert flag icon.
- Bubbles: outgoing right-aligned blue with rounded corners, incoming left grey, show avatar thumb for latest incoming message, timestamp under latest bubble cluster, use `ListView` with `slidable` style padding.
- Input area: pill-shaped text field, send button, plus button for GIF/photo (stub for now).
- Implement match metadata banner (“You matched on …”) pinned above message list.
- Dark/light theme compliance and accessible contrast.

### 5.3 Settings Bottom Sheet

- Trigger from profile screen and discover tab overflow icon.
- Modal bottom sheet covering 80% height containing sections: Discovery Preferences (age range slider, distance slider, gender multi-select chips), Location (current city display + “Use device location” stub), Notification toggles.
- Persist selections locally using `SharedPreferences` abstraction; show inline helper text for each control.
- Validate ranges (age min 18, max 80, distance 1-100 km) and provide reset-to-default button.

### 5.4 Data Model Layer

- Define Dart classes in `lib/models/`: `UserProfile`, `PreferenceSettings`, `Match`, `Message`, `Conversation` with JSON serialization (`json_serializable` or manual `fromJson`/`toJson`).
- Models store typed fields matching UI needs (e.g., `List<String> photos`, `Gender identity` enum, `MessageStatus` enum).
- Update UI layers to consume models rather than inline maps, centralizing sample data in `lib/data/mock_repositories.dart`.
- Provide repository interfaces (`ProfileRepository`, `ConversationRepository`) to abstract backend sources.

### 5.5 FastAPI Mock Backend

- Create `/server` folder housing FastAPI app with endpoints: `GET /profiles`, `GET /profiles/{id}`, `PUT /profiles/{id}`, `GET /conversations`, `GET /conversations/{id}`, `POST /messages` (returns updated conversation), `GET /preferences/{userId}`, `PUT /preferences/{userId}`.
- Seed in-memory data structures mirroring Dart models; provide deterministic mock data for one logged-in user plus 5-10 matches.
- Include `requirements.txt`, startup script, and README snippet for running (`uvicorn main:app --reload`).
- Add simple auth stub (hard-coded user token) and CORS enabled for local Flutter usage.
- Document contract in PRD appendix and ensure JSON matches model schemas.

## 6. Non-Functional Requirements

- Maintain Flutter 3.9 compatibility, Material 3 conventions, responsive layouts on phone/tablet.
- Ensure analyzer, formatter, and widget tests run through CI instructions (`flutter analyze`, `flutter test`).
- Document new flows and settings in `AGENTS.md`, update `plan.md`, and log progress in `progress.md` after each phase.

## 7. Dependencies & Risks

- Dependency on asset availability for additional profile photos; create placeholder pipeline if assets missing.
- Potential complexity introducing `json_serializable`; confirm build_runner integration.
- FastAPI server requires Python 3.10+; ensure contributors document environment setup.
- Risk of UI regressions in swipe deck while restructuring navigation; add snapshot tests or golden tests where possible.

## 8. Open Questions

- Confirm whether authentication is needed beyond token stub.
- Determine long-term storage: will FastAPI persist or stay mock?
- Should chat support typing indicators/read receipts in later iterations?

## 9. Appendix: Sample Data Contracts

```json
UserProfile {
  "id": "string",
  "displayName": "Angel",
  "age": 27,
  "jobTitle": "Product Designer",
  "bio": "Designing joyful experiences.",
  "city": "San Francisco",
  "photos": ["https://..."],
  "gender": "female",
  "interestedIn": ["male"],
  "distanceKm": 8
}
```

```json
Conversation {
  "id": "string",
  "matchId": "string",
  "participantIds": ["user-1", "user-2"],
  "messages": [
    {
      "id": "msg-1",
      "senderId": "user-1",
      "sentAt": "2024-03-10T21:00:00Z",
      "body": "You're really pretty!",
      "status": "sent"
    }
  ]
}
```
