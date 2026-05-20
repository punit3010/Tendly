# Tendly — Flutter Project

## Project structure
```
lib/
  main.dart                  ← App entry point + routes
  theme/
    app_theme.dart           ← All colors, typography, button styles
  widgets/
    tendly_logo.dart         ← Reusable logo + icon widget
  screens/
    sign_in_screen.dart      ← Screen 1 ✅ DONE
    home_screen.dart         ← Screen 2 (next)
    story_screen.dart        ← Screen 3
    profile_screen.dart      ← Screen 4
    paywall_screen.dart      ← Screen 5
```

## Setup — do this once

### 1. Install Flutter
https://docs.flutter.dev/get-started/install

### 2. Download Poppins font files
Go to https://fonts.google.com/specimen/Poppins
Download: Poppins-Regular.ttf, Poppins-Medium.ttf, Poppins-SemiBold.ttf
Place them in: `assets/fonts/`

### 3. Create asset folders
```bash
mkdir -p assets/fonts assets/images
```

### 4. Install dependencies
```bash
flutter pub get
```

### 5. Run the app
```bash
flutter run
```

## Services to wire up (in order)

| Service     | File                      | Status     |
|-------------|---------------------------|------------|
| Supabase    | sign_in_screen.dart       | Stubbed ⏳ |
| RevenueCat  | paywall_screen.dart       | Not built  |
| Google Auth | sign_in_screen.dart       | Stubbed ⏳ |
| Apple Auth  | sign_in_screen.dart       | Stubbed ⏳ |
| Claude API  | story_screen.dart         | Not built  |

## Brand
- Primary color: #1D9E75
- Font: Poppins
- Name: Tendly (placeholder — can rename before App Store submission)
