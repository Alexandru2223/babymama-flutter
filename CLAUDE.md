# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run the app (default device)
flutter run

# Run on a specific platform
flutter run -d chrome        # Web
flutter run -d windows       # Windows
flutter run -d android       # Android
flutter run -d ios           # iOS

# Run tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Build
flutter build apk            # Android APK
flutter build ios            # iOS
flutter build web            # Web
flutter build windows        # Windows

# Lint / analyze
flutter analyze

# Get dependencies
flutter pub get
```

## Architecture

Flutter multi-platform app (Android, iOS, macOS, Linux, Windows, Web) for Romanian-speaking mothers of newborns and infants. Features: baby activity tracking (sleep, feeding, diapers), age-matched development insights, parenting tips, and community discussion previews.

```
lib/
├── main.dart                        # App entry point, MaterialApp, named routes
├── theme/
│   └── theme.dart                   # Full design system (colors, typography, spacing,
│                                    # radius, shadows, button/input styles, ThemeData)
├── components/
│   ├── components.dart              # Barrel export
│   ├── buttons.dart                 # PrimaryButton, SecondaryButton
│   ├── text_input_field.dart        # Styled TextFormField wrapper
│   ├── section_title.dart           # SectionTitle (title + subtitle)
│   ├── progress_header.dart         # ProgressHeader (step bar + back button + title)
│   ├── selectable_card.dart         # SelectableCard (emoji + title + subtitle, toggle)
│   └── chip_selector.dart           # ChipSelector
├── services/
│   ├── services.dart                # Barrel export + lazy singletons (no DI framework)
│   ├── api_client.dart              # HTTP client; base URL 10.0.2.2:3000 (Android emulator);
│   │                                #   auto-refreshes access token on 401
│   ├── storage_service.dart         # flutter_secure_storage: tokens + active baby ID
│   ├── auth_service.dart            # register / login / logout / email verification
│   ├── onboarding_service.dart      # save preferences / create baby / complete onboarding
│   └── home_repository.dart         # fetch home screen payload
└── screens/
    ├── splash/
    │   └── splash_screen.dart       # Route: /splash — auth gate (token check → home or welcome)
    ├── auth/
    │   ├── auth.dart                # Barrel export
    │   ├── welcome_screen.dart      # Route: /
    │   ├── signup_screen.dart       # Route: /signup
    │   ├── login_screen.dart        # Route: /login
    │   ├── check_email_screen.dart  # Route: /check-email (post-register prompt)
    │   ├── unverified_email_screen.dart  # Route: /unverified-email
    │   ├── email_verified_screen.dart    # Route: /email-verified
    │   └── _auth_widgets.dart       # AuthBackButton, SwitchAuthRow
    ├── home/
    │   └── home_screen.dart         # Route: /home — main screen after auth/onboarding
    └── onboarding/
        ├── onboarding.dart          # Barrel export
        ├── _onboarding_widgets.dart # OnboardingBottomAction (shared CTA bar)
        ├── onboarding_interese_screen.dart    # Step 1/5 — interests grid
        ├── onboarding_baby_screen.dart        # Step 2/5 — baby profile form
        ├── onboarding_tracking_screen.dart    # Step 3/5 — tracking options
        ├── onboarding_notificari_screen.dart  # Step 4/5 — notification toggles
        ├── onboarding_comunitati_screen.dart  # Step 5/5 — community selection
        └── onboarding_complete_screen.dart    # Completion — summary + CTA
```

## Named Routes

| Route                   | Screen                         | Notes                                    |
|-------------------------|--------------------------------|------------------------------------------|
| `/splash`               | `SplashScreen`                 | Auth gate — always the initial route     |
| `/`                     | `WelcomeScreen`                | Landing (unauthenticated)                |
| `/signup`               | `SignUpScreen`                 | → `/check-email` after register          |
| `/login`                | `LoginScreen`                  | → `/home` or `/onboarding/interese`      |
| `/check-email`          | `CheckEmailScreen`             | Post-register prompt; passes email as arg |
| `/unverified-email`     | `UnverifiedEmailScreen`        | Shown on login if email not verified     |
| `/email-verified`       | `EmailVerifiedScreen`          | Deep-link landing after email click      |
| `/home`                 | `HomeScreen`                   | Main screen post-auth                    |
| `/onboarding/interese`  | `OnboardingIntereseScreen`     | Step 1 — requires ≥1 selection           |
| `/onboarding/baby`      | `OnboardingBabyScreen`         | Step 2 — name + birthdate required       |
| `/onboarding/tracking`  | `OnboardingTrackingScreen`     | Step 3 — requires ≥1 selection           |
| `/onboarding/notificari`| `OnboardingNotificariScreen`   | Step 4 — toggles, all optional           |
| `/onboarding/comunitati`| `OnboardingComunitatiScreen`   | Step 5 — passes `OnboardingCompletionData` as args |
| `/onboarding/complete`  | `OnboardingCompleteScreen`     | Reads `OnboardingCompletionData` from route args |

## Design System (`lib/theme/theme.dart`)

**Fonts:** Cormorant Garamond (display/headlines) · DM Sans (body/labels)
> `google_fonts: ^6.2.1` is listed as a planned dependency but not yet added to `pubspec.yaml`. Font families are currently referenced as plain strings.

**Key color tokens:**

| Token                        | Value       | Use                        |
|------------------------------|-------------|----------------------------|
| `BabyMamaColors.primary`     | `#C4847A`   | Muted terracotta rose       |
| `BabyMamaColors.primaryLight`| `#DDAFA9`   | Blush                       |
| `BabyMamaColors.primaryDark` | `#9C5F56`   | Deep rose                   |
| `BabyMamaColors.accent`      | `#D4B896`   | Warm champagne gold         |
| `BabyMamaColors.secondary`   | `#9BAF9B`   | Muted sage green            |
| `BabyMamaColors.background`  | `#FDF8F5`   | Warm cream                  |
| `BabyMamaColors.surface`     | `#FFFFFF`   |                             |
| `BabyMamaColors.surfaceVariant` | `#F5EDE8` | Linen                      |
| `BabyMamaColors.neutral900–50` | scale    | Warm-tinted grays           |

Available neutral steps: `neutral900`, `neutral700`, `neutral500`, `neutral300`, `neutral100`, `neutral50`. There is **no `neutral400`** — use `neutral500` as the nearest alternative.

**Spacing scale** (`BabyMamaSpacing`): `xs2=2` · `xs=4` · `sm=8` · `md=12` · `lg=16` · `xl=20` · `xl2=24` · `xl3=32` · `xl4=40` · `xl5=48` · `xl6=64`

**Border radius** (`BabyMamaRadius`): `smAll=8` · `mdAll=12` · `lgAll=16` · `xlAll=24` · `fullAll=999` — semantic aliases: `card=mdAll`, `button=fullAll`, `input=smAll`, `modal=lgAll`

**Shadows** (`BabyMamaShadows`): `xs` · `sm` · `md` · `lg` · `xl` — all warm-tinted (avoid cold gray)

## Onboarding Data Flow

Data is currently **local state only** — no state management library is in use. The completion screen accepts `OnboardingCompletionData` via route arguments:

```dart
class OnboardingCompletionData {
  final String? babyName;      // from OnboardingBabyScreen (not yet threaded)
  final Set<String> interests; // from OnboardingIntereseScreen (not yet threaded)
  final Set<String> communities; // passed by OnboardingComunitatiScreen ✓
}
```

`babyName` and `interests` are not yet threaded through — the comunitati screen only passes `communities`. Adding state management (e.g. Riverpod or Provider) is the prerequisite for full data threading.

## Conventions

- Every screen imports `../../theme/theme.dart` and `../../components/components.dart`.
- Onboarding screens share `_onboarding_widgets.dart` for `OnboardingBottomAction` (fixed bottom CTA bar with optional `isLoading` and `hint`).
- Selected state in onboarding uses `Set<String>` with value keys (e.g. `'alaptare'`, `'somn'`).
- Animated selection feedback uses `AnimatedContainer` + `Material`/`InkWell` — no external animation packages.
- Entrance animations (completion screen) use a single `AnimationController` with staggered `Interval` curves.
- All backend calls go through `ApiClient` from `lib/services/`. Every screen that touches the API imports from `../../services/services.dart` and catches `ApiException` for error display.

## Stack

- Flutter (Dart SDK ^3.11.4)
- Material 3 (`useMaterial3: true`)
- `http: ^1.2.2` — HTTP client used by `ApiClient`
- `flutter_secure_storage: ^9.2.2` — encrypted token storage
- `flutter_localizations` — Romanian (`ro`) primary locale, English fallback
- `cupertino_icons: ^1.0.8`
- No state management library — local `setState` only
- `google_fonts` is planned but not yet added to `pubspec.yaml`; font families are referenced as plain strings in the theme
