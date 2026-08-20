# Monopoly Helper — Architecture & Code Guide

This document explains how the app is organized and what every file does,
so you don't have to re-read the whole codebase next time you come back
to it. It also lists the judgment calls made while turning the brief into
working code, so you know what's a deliberate design decision vs. what's
a placeholder waiting for real data.

Read this top to bottom once, then use it as a reference — each section
below maps 1:1 to a folder under `lib/`.

---

## 1. What changed from the previous version

The old codebase had a lot of screens and state that the running app
never actually showed. `main.dart` only ever built `MonopolyHelperHomeScreen`
— it never built `AppNavigationShell`, which is where the dashboard,
player/bank management, dice roller, chance cards, history log and
settings screens all lived. Since nothing pointed to `AppNavigationShell`,
that entire tree (about half the codebase, including the dice widget) was
dead code: present in the project, compiled, but unreachable from the app
a person actually opens. A few standalone widgets (`GlassContainer`,
`CustomButton`, `ArabicTextHelper`, `AppTextStyles`) were unused too.

This version deletes all of that and rebuilds the app around exactly the
flow described in the brief: a pinned player bar, a three-stage turn loop
(moves → challenge → results), and a pinned bottom button that opens a
navigation panel. Nothing in `lib/` is unreachable from `main.dart` anymore.

The 14 mini-games' wording, rules, scoring and datasets are untouched —
only *how* each game's widget is split (see §4) and *where* it's hosted
in the UI changed.

---

## 2. Folder structure

```
lib/
├── main.dart                     Entry point
├── app.dart                      MaterialApp, theme, RTL, localization
├── core/
│   ├── constants/                App-wide constants (colors, strings, tuning numbers)
│   ├── theme/                    ThemeData
│   ├── utils/                    Small stateless helpers (timer, sound, responsive scaling)
│   └── widgets/                  Small reusable widgets used across features
├── data/
│   ├── models/                   Plain data classes (CityModel, PlayerModel)
│   └── datasets/                 Static content: mini-game question banks, cities, nav tips
└── features/
    ├── mini_games/                The 14 games + the difficulty/manager machinery
    ├── game_session/              The turn loop: state + the 3 pages + their widgets
    ├── challenge_picker/          The "pick any game" modal sheet
    └── home/                      The screen shell: player bar, main frame, nav panel, pinned button
```

Each feature folder is split into `state/` (a `ChangeNotifier`, if the
feature has one) and `presentation/` (widgets), following the pattern the
project already used for `mini_games`.

---

## 3. `core/` — shared building blocks

### `core/constants/app_colors.dart` *(unchanged)*
Every color used anywhere in the app: brand colors, difficulty-tier
colors (`easyTier`/`mediumTier`/`hardTier`), status colors, and the
player color palette.

### `core/constants/app_strings.dart` *(extended, nothing removed)*
Every piece of Arabic copy in the app. All strings from the previous
version are kept verbatim (mini-game titles/descriptions, difficulty
labels, timer controls...). New strings were added for the pieces the
brief introduced that didn't exist before: the moves-selection prompt,
the results-page headlines, the buy/pay button labels, the pay
confirmation sheet, and the navigation panel. If you need to change any
wording, this is the only file you need to touch.

### `core/constants/game_constants.dart` *(unchanged)*
Tunable numbers: starting cash, each difficulty tier's default
reward/penalty, and every mini-game's time limit in seconds.

### `core/theme/app_theme.dart` *(simplified)*
One `ThemeData` (`AppTheme.theme`), dark only. The old light theme and
the `ThemeProvider` that toggled it were removed because the only control
that exposed the toggle (the footer of the old sidebar) was removed per
the brief ("remove the bottom part... that changes themes"). Re-adding a
toggle later just means adding `AppTheme.lightTheme` back and wiring a
switch into `NavigationPanel`.

### `core/utils/timer_helper.dart` / `core/utils/sound_helper.dart` *(unchanged)*
`GameTimerController` is a small countdown timer (`start`/`pause`/`reset`/
`stop`, a `totalSeconds`/`onTick`/`onTimeUp` API) used by
`GameSessionController` to drive the challenge countdown.
`SoundHelper` triggers haptic feedback (there's no audio asset, so
"sound" is currently just `HapticFeedback` calls) for win/lose/tick
events.

### `core/utils/responsive.dart` *(new)*
This is what makes font/spacing sizes adapt to the screen (brief item 3).
It adds extension getters on `BuildContext`:
- `isMobile` / `isTablet` / `isDesktop` — width breakpoints.
- `uiScale` — a multiplier (roughly 0.8–1.45) computed from the window
  width against a reference size for each breakpoint (1440px desktop,
  900px tablet, 390px phone), clamped so it never gets silly. Almost
  every widget in `features/` multiplies its font sizes/icon sizes/
  paddings by this (`14 * scale`, `Icon(..., size: 20 * scale)`, etc.)
  instead of hard-coding a single value that would look fine on one
  screen and wrong on the others.
- `sp(base)` — shorthand for `base * uiScale`.

### `core/widgets/scale_to_fit.dart` *(new)*
The other half of the "nothing should ever overflow or scroll" story
(brief items 2 & 3). `ScaleToFit` lays its child out at a fixed
*reference width* (so `Wrap`/`GridView` inside it wrap at a sensible
width) and then uses a `FittedBox(fit: BoxFit.scaleDown)` to shrink the
whole thing down — uniformly, never up — so it always fits whatever space
its parent gives it. This is used to wrap the mini-game area on the
challenge page and the whole body of the results page, both of which have
content whose height varies a lot (a mini-game with 2 answer buttons vs.
one with 5 category rows; a results page with 2 buttons vs. 4). Rather
than hand-tuning font sizes per case, the block just scales down as a
whole when it doesn't fit — no `SingleChildScrollView` needed anywhere in
the main turn loop.

### `core/widgets/confetti_overlay.dart` *(new)*
A small hand-rolled confetti effect (`CustomPainter`-based, no external
package). `ConfettiOverlay(play: bool, palette: ConfettiPalette)`:
- `play: true` starts a ~2.6s burst of falling, rotating particles.
- `ConfettiPalette.colorful` (bright mixed colors) is used when a player
  wins outright; `ConfettiPalette.golden` (gold/amber) is used when they
  paid to move despite losing, per the brief.
- It's wrapped in `IgnorePointer`, so it never blocks taps on the results
  page underneath it.

### `core/widgets/custom_card.dart`, `difficulty_badge.dart`, `game_timer_widget.dart` *(unchanged)*
Small presentational widgets reused from the previous version:
`CustomCard` (a themed, bordered container), `DifficultyBadge` (the small
colored "سهل/متوسط/صعب" pill), and `GameTimerWidget` (the circular
countdown ring used on the challenge page).

---

## 4. `data/` — models and static content

### `data/models/city_model.dart` *(new)*
```dart
CityModel(idx, name, colorOnBoard, colorOnCard,
          basePrice, baseFee, garagePrice, garageFee, marketPrice, marketFee)
```
Field names mirror the shape described in the brief so the placeholder
list in `cities_data.dart` can be swapped for the real dataset later with
no code changes anywhere else.

### `data/models/player_model.dart` *(new, replaces the old, much bigger PlayerModel)*
Only what the new turn loop needs: `id`, `name`, `color`, `balance`,
`position` (index into `CitiesData.all` — where the player's piece
currently is), and three index lists: `ownedCityIndices`,
`ownedGarageIndices`, `ownedMarketIndices`.

> **Note on the extra two lists.** The brief asked for "a list of indices
> ... for what cities they own." That's `ownedCityIndices`. Garage and
> market ownership needed to be tracked *somehow* too (so those buy
> buttons can independently show "buy" vs. "bought"), so two more lists
> were added, following the exact same pattern. This is the one place the
> implementation adds structure beyond what was explicitly asked for.

`PlayerModel.initials` builds the results-page crown badge text (e.g.
"أحمد علي" → "أع"), keeping an Arabic base letter together with a
following diacritic if there is one, so initials never end up as a lone
invisible mark.

### `data/datasets/cities_data.dart` *(new, placeholder — replace this later)*
`CitiesData.all` is a `List<CityModel>` of 22 Egyptian
cities/governorates (Cairo, Alexandria, Luxor, Aswan, ...), matching the
"روح القاهرة" example from the brief, with made-up but internally
consistent prices/fees. **This is explicitly placeholder data** — the
brief said the real dataset will be provided later. To swap it in:
replace the contents of `CitiesData.all` with the real `CityModel(...)`
entries. Nothing else in the app needs to change, since every screen only
ever reads through `CitiesData.all` / `CitiesData.byIndex(i)`.

### `data/datasets/navigation_tips_data.dart` *(new)*
`NavigationTipsData.tips` — the list of short Arabic hint lines the
pinned bottom button cycles through. Add/edit/remove lines here; no UI
code needs to change.

### `data/datasets/*.dart` (the other 13 files) *(unchanged)*
The full question/word banks for the 14 mini-games — untouched, both
content and API (`getRandom()` / `generateChallenge()` / etc.).

---

## 5. `features/mini_games/` — the 14 games

### `core/mini_game_difficulty.dart` *(unchanged)*
The `MiniGameDifficulty` enum (`easy`/`medium`/`hard`) with its label,
color, icon, and default reward/penalty for each tier.

### `core/mini_game_manager.dart` *(unchanged)*
A singleton registry of all 14 game instances, with
`getGamesByDifficulty(difficulty)`, `getRandomGame(difficulty: ...)`, and
`getGameById(id)`. Used by `GameSessionController` to pick games and by
`ChallengePickerPanel` to list/filter them.

### `core/base_mini_game.dart` *(changed: one method became two)*
Every game used to implement a single `buildChallengeWidget(...)` that
returned its entire UI (question + answer controls) as one widget. The
brief's new challenge-page layout needs the timer to sit *next to* just
the question, with the answer controls in their own row underneath, so
`BaseMiniGame` now declares two methods instead:
- `buildQueryWidget(context)` — just the prompt (the letter, the word,
  the math expression, the trivia question...).
- `buildInteractionWidget(context, {onGameWon, onGameLost})` — the
  buttons/inputs the player uses to answer or self-judge.

### `easy/`, `medium/`, `hard/` (14 files) *(mechanically split, logic/text unchanged)*
Each game file's wording, `rules` text, dataset calls, scoring logic, and
reward/penalty amounts are exactly what they were before. The only change
is splitting each file's old `buildChallengeWidget` body into the two
methods above — usually "the first `CustomCard`" became
`buildQueryWidget` and "everything after it" became
`buildInteractionWidget`. A couple of games (`FitnessChallengesGame`,
`TongueTwistersGame`) only ever had a query + a fixed pair of
win/lose buttons with nothing in between, so their
`buildInteractionWidget` is just those two buttons.

---

## 6. `features/game_session/` — the turn loop

This is the heart of the app: the "main frame" that loops moves-selection
→ challenge → results → (next player's) moves-selection → ... forever.

### `state/game_session_controller.dart`
A single `ChangeNotifier` that owns *all* gameplay state — the list of
`PlayerModel`s, whose turn it is, which stage is showing, the current
mini-game and its timer, and the results page's buy/pay logic. Nothing
else in `features/game_session` or `features/home` holds its own
gameplay state; every page just reads from this controller and calls
methods on it.

Key pieces:

- **`TurnStage`** — `movesSelection` / `challenge` / `results`. Which of
  the three pages `GameSessionFrame` shows.
- **`ChallengeOutcome`** — `undetermined` / `won` / `lost`. Drives the
  bottom toolbar (§6.4).
- **`MoveResolution`** — `none` / `wonFree` / `paidToMove` / `stayed`.
  What ultimately happens to the player's move this turn; drives the
  results page's headline, confetti, and which city counts as "relevant."
- **`difficultyForSteps(steps)`** — the 1-9 → easy/medium/hard banding
  used by both the steps grid's row coloring and the actual game picked.
- **`selectSteps(steps)`** — stage 1's action: records the chosen steps,
  computes the destination city (`position + steps`, wrapped with `%` so
  it never runs off the end of `CitiesData.all`), picks a random game at
  the right difficulty, and switches to the challenge stage.
- **`markChallengeWon` / `markChallengeLost`** — called by whichever
  mini-game's `onGameWon`/`onGameLost` callback fires.
- **`confirmWonMove` / `chooseDontMove` / `confirmPaidMove`** — the three
  bottom-toolbar outcomes; each sets `moveResolution` and moves to the
  results stage. `confirmPaidMove` is the only one that touches money at
  this stage (subtracts the mini-game's `penaltyAmount`).
- **`relevantCityIndex`** — the city the results page's buy/pay UI
  operates on: the destination if the player moved this turn, otherwise
  wherever they already are. This is what lets "stayed" and "moved" share
  one code path for the buy/pay section instead of needing two.
- **`buyBase` / `buyGarage` / `buyMarket`** — used when the relevant city
  is unowned or already owned by the active player. Each checks
  ownership + affordability before doing anything.
- **`buyFromOwner` / `payOwnerAndFinishTurn`** — used when the relevant
  city belongs to *another* player; both end the turn immediately, per
  the brief.
- **`finishTurn`** — the explicit "أنهى الدور" button's action, used only
  in the "unowned/mine" branch.
- **`endTurn`** — applies the move (updates `activePlayer.position` if
  they actually moved), advances `activePlayerIndex` to the next player,
  and resets all per-turn state back to stage 1.

### `presentation/game_session_frame.dart`
A thin `AnimatedSwitcher` that shows whichever page matches
`controller.stage`. This *is* the "infinite loop" from the brief — there's
no navigation stack, just one enum driving which widget is on screen.

### `presentation/pages/moves_selection_page.dart` (stage 1)
The explanatory line + the 3×3 `StepsGrid`, laid out with `Expanded` so
it always fits without scrolling (its content doesn't vary, so it didn't
need the `ScaleToFit` treatment the other two pages use).

### `presentation/widgets/steps_grid.dart`
The 1–9 grid. Row coloring comes from
`GameSessionController.difficultyForSteps` (row 1 = easy color, row 2 =
medium, row 3 = hard). Sizes itself via `LayoutBuilder` to the largest
square that fits the space it's given — never scrolls, never overflows,
at any window size.

### `presentation/pages/challenge_page.dart` (stage 2, the "Games screen")
Top to bottom: game icon/title/difficulty → `RulesBanner` → (inside
`ScaleToFit`) the timer next to the query widget in a `Row` on desktop /
stacked in a `Column` on phones, then the interaction widget below → the
bottom toolbar. `_TimerBlock` is the little private widget with the
circular timer + play/pause/reset buttons (visually unchanged from the
previous version, just relocated).

### `presentation/widgets/rules_banner.dart`
The single-line, ellipsized rules summary. Tapping it opens an
`OverlayPortal` (a `CompositedTransformFollower` anchored under the
banner) showing the full rules text as a floating card — it's painted in
the app's `Overlay`, not in the normal widget tree, so it can never push
any other widget around, and tapping anywhere else closes it.

### `presentation/widgets/bottom_action_toolbar.dart`
Reads `ChallengeOutcome` and shows the right combination of buttons:
- `undetermined` → only "تحدي جديد" (new challenge).
- `won` → + a **disabled** "لا تتحرك" (don't move) and an enabled
  "تم، التالي".
- `lost` → + an **enabled** "لا تتحرك" and "ادفع Nم£+ وتحرك" (which opens
  the confirmation dialog before actually charging anything).

### `presentation/dialogs/pay_confirmation_dialog.dart`
The "are you sure?" dialog shown before paying to move after losing.
Returns `true`/`false`; `ChallengePage` only calls
`controller.confirmPaidMove()` if the user confirmed.

### `presentation/pages/results_page.dart` (stage 3)
Also wrapped in `ScaleToFit` (the number of buy buttons shown varies
between 2 and 4, so a fixed `Expanded` split isn't safe on short
screens). Shows, top to bottom: the outcome headline, the
destination/stay line + owner crown badge, the `CityImageFrame`, then
either the "owned by another player" pair of buttons or the
buy-base/garage/market + "أنهى الدور" block — chosen by
`controller.relevantCityOwnedByOther`. A `ConfettiOverlay` sits in a
`Positioned.fill` sibling outside the scaled content, so it always covers
the whole page regardless of how much the content itself is scaled down.

### `presentation/widgets/city_image_frame.dart`
Locked to a 16:9 `AspectRatio` so it can never be the reason the page
overflows, `BoxFit.cover` so the image always fills the frame (cropping,
never stretching). No real photos ship with the app — see §8. Two thin
"rail" buttons overlap the left/right edges at 40% of the frame's height;
tapping either shows a tooltip ("اللون على الكارت" on the left / "اللون
على اللوحة" on the right, per the brief).

### `presentation/widgets/city_action_button.dart`
The reusable buy/bought row (icon, label, price + rent on the trailing
side) used for the base/garage/market buttons. Automatically disables
itself and swaps its label when `isOwned` is true, or grays out the price
when the player can't afford it.

### `presentation/widgets/owner_badge.dart`
The golden-crown + colored-initials badge shown next to the
destination/stay line when the relevant city has an owner.

---

## 7. `features/challenge_picker/` — the "new challenge" list

### `presentation/challenge_picker_panel.dart`
This is what used to be the always-on-screen sidebar/drawer
(`game_sidebar.dart`). Same filter chips + "random game" button + game
list, minus the footer that toggled the theme and showed a win counter
(explicitly asked to be removed).

### `presentation/show_challenge_picker.dart`
`showChallengePicker(context, {initialDifficulty})` wraps
`ChallengePickerPanel` in a `showModalBottomSheet` — narrow/full-width on
phones, a centered ~460px-wide sheet on desktop. Returns the
`BaseMiniGame` the player tapped (or `null` if they dismissed it).
`ChallengePage`'s "new challenge" button calls this, then hands the
result to `controller.pickChallengeManually(...)`.

---

## 8. `features/home/` — the screen shell

### `presentation/home_screen.dart`
Owns the one `GameSessionController` for the whole app session and
assembles everything else:

```
Scaffold(body: Column(
  PlayerStatusBar(...)                    // pinned top
  Expanded(child: Stack(
    GameSessionFrame(...)                 // moves -> challenge -> results
    if (nav open) barrier (tap to close)
    AnimatedPositioned(NavigationPanel)   // slides in only within this Stack
  ))
  MarqueeNavButton(...)                   // pinned bottom
))
```

The player bar and the pinned button are siblings of the `Expanded` /
`Stack`, not inside it — that's the whole trick behind "always visible,
even when the sidebar is open": the sliding panel physically can't reach
them, so there's no visibility/elevation logic needed anywhere else.
`AnimatedPositioned`'s `left`/`right` are chosen based on
`Directionality.of(context)` so the panel slides in from the correct
(start) edge in RTL.

There's no `Scaffold.appBar` at all, per "no navigation bar at the top."

### `presentation/widgets/player_status_bar.dart`
The pinned, horizontally-scrollable player row. Each card shows the
player's name and current city (looked up via
`CitiesData.byIndex(player.position)`), full opacity + a white border +
a glow when active, 45% opacity + a slight scale-down otherwise.
Whenever `activePlayerIndex` changes, `Scrollable.ensureVisible(...,
alignment: 0.5)` animates the active card to the horizontal center.

### `presentation/widgets/marquee_nav_button.dart`
The pinned bottom button. A fixed icon sits in a reserved slot on the
left; to its right, `_currentText` glides from fully off-screen right to
fully off-screen left using a plain `AnimationController` +
`Transform.translate` (no dependency on text direction — the motion is
always physically right-to-left, independent of the Arabic text's own
shaping). The animation's `duration` is recomputed from the current
text's length so short and long lines glide at roughly the same visual
speed. When the animation completes, a new random line is picked (never
repeating the immediately-previous one) via
`NavigationTipsData.tips`, and the cycle restarts — forever. The moving
text is wrapped in `IgnorePointer` and clipped to stay out of the icon's
slot, so neither can ever block the tap that opens/closes the panel —
the whole button is one `InkWell`.

### `presentation/widgets/navigation_panel.dart`
The panel's content: the app name/subtitle + a "coming soon" note, per
the brief ("just have the name of the app... ignore [settings/player
editing] for now"). Add new sections here later.

---

## 9. `app.dart` / `main.dart`

`main.dart` is just `runApp(const MonopolyHelperApp())`.
`app.dart` builds the `MaterialApp` (theme, Arabic/English localization
delegates, `Locale('ar', 'EG')`) and wraps `HomeScreen` in a top-level
`Directionality(textDirection: TextDirection.rtl)`, matching the
previous version.

---

## 10. Design decisions worth knowing about

- **No router / navigation stack.** The whole app is one screen; the
  "pages" are an enum-driven switch inside `GameSessionFrame`, not
  `Navigator` routes. This matches the brief's "infinite loop" framing
  and keeps back-button/deep-linking concerns out of scope.
- **`provider` package removed.** The old app depended on it for
  `ThemeProvider`/`MiniGameState`. The new app has exactly one piece of
  shared state (`GameSessionController`), owned by `HomeScreen` and
  passed down as a constructor parameter, with a plain
  `addListener`/`setState`. If the app grows more independently-updating
  state later, reintroducing `provider` (or `ChangeNotifierProvider`) is
  a small, mechanical change.
- **Winning a challenge doesn't pay a reward.** The brief's bottom
  toolbar only ever mentions a payment when the player *loses* and pays
  to move anyway; there's no mention of a cash reward for winning. So
  `confirmWonMove()` moves the player for free without touching balance.
  `BaseMiniGame.rewardAmount` still exists (each game still declares one,
  inherited from the previous version) in case a future revision wants to
  pay it out on `confirmWonMove()` — it's just not used right now.
  Losing-and-paying does use `penaltyAmount`.
- **No jail, no dice, no bankruptcy.** These existed in the old
  `PlayerProvider` but have no place in the flow described in the brief
  (steps are chosen by the player, not rolled). They were dropped rather
  than carried along unused.
- **`assets/data/`** (declared in the old `pubspec.yaml` but never
  actually read by any code) was replaced with `assets/images/cities/`,
  which `CityImageFrame` does read from.
- **Flutter/Dart SDK constraints were bumped** in `pubspec.yaml` (to
  Dart `>=3.5.0`, Flutter `>=3.27.0`). The previous constraints
  (`>=3.10.0`) were already stale — the code uses `Color.withValues(...)`
  and `OverlayPortal`, both of which need a materially newer Flutter than
  3.10. Run `flutter pub get` after pulling these changes; since a
  dependency (`provider`) was removed, `pubspec.lock` needs to be
  regenerated rather than reused as-is.

---

## 11. Two things you'll want to do next

1. **Swap in the real city dataset.** Replace the list in
   `lib/data/datasets/cities_data.dart` with the real data, keeping the
   same `CityModel` shape. Nothing else changes.
2. **Add real city photos.** Drop `0.jpg`, `1.jpg`, ... (named after each
   city's `idx`) into `assets/images/cities/`. Until a given index has a
   photo, `CityImageFrame` shows a themed placeholder automatically, so
   the app works fine either way.
