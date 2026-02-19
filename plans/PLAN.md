# PopSearch — MVP Product Requirements Document (PRD)
**Platforms:** iOS + Android (Flutter)  
**Design:** Soft / smooth UI, user-switchable theme  
**Monetization (MVP):**
- **iOS:** Paid app (closest price tier to ~USD $1), **no ads**
- **Android:** Free app with **one small banner ad** (strictly non-disruptive)

---

## 0) Service Name
### Primary name
- **PopSearch**

### Backup options
- OneTap Search
- QuickSearch
- JumpSearch

> Note: Do **not** use third-party brand names (Google/YouTube/Naver, etc.) in the app name, subtitle, or icon to avoid trademark/affiliation issues.

---

## 1) Product Summary
PopSearch is a “search launcher” utility.

When the user opens PopSearch:
1) a search field appears immediately (keyboard opens automatically),  
2) the user selects a search engine quickly,  
3) pressing Enter / tapping “Go” opens the results in the system’s default browser,  
   or opens the native app when appropriate (e.g., YouTube).

**Core promise:** Tap → type → go.

---

## 2) Goals (MVP)
- **Minimize friction:** the first screen is always the search UI (no home screen).
- **Engine switching:** user can change search engine instantly.
- **Fast external handoff:** open results in default browser / YouTube app.
- **Soft design & theme:** calm visuals + System/Light/Dark.
- **Store-guideline friendly:** no OS-restricted behaviors on iOS; ads on Android are minimal and non-disruptive.

---

## 3) Non-Goals (Not MVP)
- Custom engines (user-defined URL templates)
- Multi-engine search (open multiple engines at once)
- Voice search
- iOS widgets / shortcuts / share extension
- Android system-wide overlay (“draw over other apps”), quick settings tile, floating bubble
- Accounts, cloud sync, cross-device history

---

## 4) Target Users
- People who search frequently and want fewer steps
- Users who switch engines often (Google ↔ Naver ↔ YouTube)
- Students / researchers / shoppers comparing sources quickly

---

## 5) Key User Flows

### Flow A — Basic Search (Primary)
1. User opens PopSearch.
2. Search UI appears instantly; keyboard is shown.
3. User types a query.
4. User presses Enter or taps “Go”.
5. PopSearch opens:
   - default browser → results page, or
   - YouTube app (if installed) → results, otherwise YouTube web

### Flow B — Switch Engine
1. User taps the engine selector.
2. Engine list appears.
3. User selects an engine.
4. Selection is remembered for next time.

### Flow C — Use Recent Searches
1. User opens PopSearch.
2. Recent searches are visible (local list).
3. User taps a recent query to reuse and search immediately.

### Flow D — Settings (Theme + History)
1. User opens Settings from the search screen.
2. User changes theme (System/Light/Dark) and/or clears history.

### Flow E — Cancel / Dismiss
- iOS: “Cancel/Close” dismisses the keyboard and returns to the search screen state.
- Android: Back button closes current sheet/dialog and returns to the search screen; leaving the app is normal Android behavior.

---

## 6) Platform Behavior (MVP)

### 6.1 Common behavior (iOS + Android)
- App always opens directly into the search UI.
- External destinations open only after explicit user action (Enter/Go).
- Default browser is respected (do not force Chrome/Safari in MVP).
- No ads on iOS; Android ads must never block the core search flow.

### 6.2 iOS
- **No system-wide overlay.** PopSearch is a fast launcher screen.
- UI uses iOS-appropriate patterns (Cupertino feel: typography, motion, spacing).
- Since the app is paid, the experience must feel polished:
  - instant focus & keyboard
  - consistent animations
  - reliable engine switching and handoff

### 6.3 Android
- Use Material 3 components and standard Android navigation behavior.
- Keep startup fast; show the search UI immediately.
- Ads are **Android-only** and placed in a non-disruptive location (defined below).

---

## 7) MVP Feature Requirements

### 7.1 Instant Search UI
**Required UI elements**
- Engine selector (chip/button)
- Search text field
- Clear (X) action
- Go (arrow) button
- Recent searches list (compact)

**Behavior**
- On screen load: focus the text field and show keyboard.
- Enter key triggers search.
- Go button triggers search.
- Tapping a recent item fills and runs the search (or fills only—choose one behavior and keep consistent).

### 7.2 Engine Selector (MVP engines)
- Google
- YouTube
- Naver
- Daum
- Yahoo

**Rules**
- Remember last-used engine.
- Use generic icons or text labels to avoid brand asset licensing problems.
- Provide a short disclaimer in Settings/About:
  - “Not affiliated with Google, YouTube, Naver, Daum, or Yahoo.”

### 7.3 Search Execution & Handoff
- URL-encode the query and open the engine URL.
- YouTube:
  - Prefer opening via universal link so the YouTube app can handle it if installed.
  - Fallback to web if not installed.

### 7.4 Recent Searches (Local-only)
- Store locally (suggested: last 20 items).
- Provide “Clear History”.
- No account required.

### 7.5 Theme Switching
- Theme modes:
  - System
  - Light
  - Dark

---

## 8) Search URL Templates (MVP)
Use `{q}` as a URL-encoded query.

| Engine  | URL Template |
|--------|--------------|
| Google | `https://www.google.com/search?q={q}` |
| YouTube | `https://www.youtube.com/results?search_query={q}` |
| Naver | `https://search.naver.com/search.naver?query={q}` |
| Daum | `https://search.daum.net/search?q={q}` |
| Yahoo | `https://search.yahoo.com/search?p={q}` |

---

## 9) Soft UI / UX Design Requirements
### 9.1 Visual style (“Soft Minimal”)
- Rounded card container for the search module
- Gentle shadows (subtle elevation only)
- Calm, low-noise background (scrim + optional blur)
- Plenty of padding and whitespace
- No harsh borders; prefer soft dividers and subtle outlines

### 9.2 Motion & Interactions
- Screen entry: short fade + slight slide
- Engine picker: smooth expand/collapse
- No jarring layout shifts (especially important for ads on Android)
- Optional haptics (post-MVP if you want to keep MVP minimal)

### 9.3 Accessibility (MVP minimum)
- Respect system text scaling
- Maintain readable contrast in Light/Dark
- Buttons are easy to tap (platform-recommended hit areas)
- Clear focus states for text input and controls

---

## 10) Android Ads (MVP — “Very Small”, Non-Disruptive)

### 10.1 Ad principle (hard rules)
- **Banner only.** No interstitials, no rewarded, no splash ads.
- Ads must never:
  - block search input or the Go action,
  - appear unexpectedly during a user action,
  - mimic app UI elements,
  - trigger on app exit/back navigation,
  - cause accidental clicks due to placement shifts.

### 10.2 Ad placement (recommended)
**Placement: Settings screen only (bottom area).**
- Rationale: keeps the core “tap → type → go” flow clean.
- The Settings screen is a safe, non-critical context where a small banner won’t interfere.

**Optional secondary placement (only if needed):**
- About screen (bottom area)

> Do **not** place ads directly adjacent to the Go button, engine selector, or near common tap-to-dismiss zones.

### 10.3 Layout & loading behavior
- Reserve a fixed-height container for the banner to prevent UI jumping.
- Load asynchronously; never delay first render of the search UI.
- If the ad fails to load, collapse the container gracefully (or show a neutral placeholder with no calls-to-action).

### 10.4 Privacy & consent (Android)
- Implement region-appropriate consent flow if required (e.g., personalized vs non-personalized ads).
- Prefer **non-personalized ads** by default to minimize privacy friction.
- Update Play Console Data Safety accordingly.

---

## 11) Monetization (MVP)
### iOS
- **Paid download** (closest price tier to ~USD $1)
- No ads
- No subscriptions in MVP

### Android
- Free download
- One small banner ad in Settings (as defined above)

---

## 12) Data & Privacy (MVP)
- Local-only storage:
  - last-used engine
  - recent searches
  - theme setting
- Provide:
  - Clear History
- No accounts, no server in MVP
- If an ad SDK is used on Android:
  - clearly document it in the privacy policy and Play Data Safety

---

## 13) Store Guideline Compliance (Implementation Constraints)
### iOS (App Store)
- Avoid restricted behaviors (no system overlays).
- Provide real native utility beyond “opening URLs”:
  - instant keyboard-focused launcher UI
  - engine switching UX
  - recent searches + clear history
  - theme switching
- Avoid brand impersonation/affiliation claims.

### Android (Google Play)
- Follow standard navigation and app quality expectations.
- Ads must be non-deceptive, non-disruptive, and shown only inside the app UI.
- Avoid any ad behavior that interferes with device functions or user actions.

---

## 14) Flutter Technical Plan (MVP)
### Shared (Flutter)
- Search screen UI
- Engine selection and persistence
- Theme system (System/Light/Dark)
- Local storage for history (e.g., shared_preferences or local DB)
- URL building + encoding
- External URL/app launching

### Android-only
- Banner ad integration (Android flavor only)
- Build flavors:
  - `androidFreeWithAds`
  - `iosPaidNoAds`

### iOS-only
- Ensure no ad SDK is included in the iOS build output.

---

## 15) MVP Definition of Done (Checklist)
- [ ] App opens directly to search UI (no extra home screen)
- [ ] Keyboard opens immediately on launch
- [ ] Engine selector works and persists last choice
- [ ] Enter / Go opens correct destination (browser / YouTube)
- [ ] Recent searches saved locally and can be cleared
- [ ] Theme: System/Light/Dark
- [ ] iOS build contains no ads and no ad SDK
- [ ] Android build shows a small banner ad only in Settings (non-disruptive)
- [ ] Privacy policy prepared (mentions Android ads + what data is stored locally)

---

## 16) Post-MVP Ideas (Optional)
- iOS: Widgets / Shortcuts / Share Extension for “search selected text”
- Android: Quick Settings tile, floating bubble launcher
- Pro features (later): custom engines, multi-engine search, advanced theming, “remove ads” purchase on Android
