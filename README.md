# SkyCast — Flutter Weather Application

SkyCast is a cross-platform weather app built for an internship project. Users can search for a city, view current conditions, and revisit recent searches. Email/password accounts are provided through Firebase when platform configuration is supplied.

## Features

- Current weather by city from OpenWeather.
- Celsius temperature, description, weather icon, feels-like temperature, humidity, wind speed, and visibility when provided by the API.
- Responsive dashboard, city search, and weather details screens.
- Loading, empty-input, invalid-city, invalid-key, timeout, and network error states.
- Recent successful searches saved on device, duplicate cities updated in recent-first order, and clear-history confirmation.
- Firebase email/password registration, login, persistent auth state, and logout after Firebase setup.
- Guest mode for weather search when Firebase has not been configured.

This version uses OpenWeather's current `/weather` endpoint. That endpoint does not return an hourly forecast, so no forecast is shown.

## Technologies

- Flutter 3.50 / Dart 3.14
- GetX for state and navigation
- Dio for HTTP requests
- OpenWeather current weather API
- GetStorage for local history
- Firebase Core and Firebase Authentication
- `flutter_dotenv` for local environment values

## Architecture

The project separates the user interface, state controllers, data access, and shared widgets:

```text
lib/
├── main.dart
├── core/
│   ├── bindings/       # App-wide GetX dependency registration
│   ├── constants/      # API endpoint and configuration keys
│   ├── routes/         # GetX route names and pages
│   └── theme/          # Shared theme
├── data/
│   ├── models/         # Weather response model
│   ├── providers/      # Dio/OpenWeather requests
│   ├── repositories/   # Provider-to-model boundary
│   └── services/       # Firebase auth and local search history
├── modules/
│   ├── auth/           # Login, registration, auth controller
│   ├── dashboard/      # Weather dashboard and city search
│   ├── history/        # Search history controller and screen
│   └── weather/        # Weather controller and details view
└── shared/widgets/     # Reusable auth and weather cards
```

## Setup

### 1. Install packages

Install Flutter 3.50 or a compatible Flutter/Dart version, then run:

```bash
flutter pub get
```

### 2. Configure OpenWeather

Copy `.env.example` to `.env` and enter your own key:

```env
OPENWEATHER_API_KEY=your_key_here
DEFAULT_CITY=London
```

`.env` is ignored by Git. Flutter includes declared assets in the built client, so the key can still be extracted from a compiled web/mobile app. Restrict the key for development and use a backend proxy for production. Rotate any key that has been exposed.

### 3. Configure Firebase (optional for guest weather)

1. Create a Firebase project and enable **Authentication → Sign-in method → Email/Password**.
2. Install and run FlutterFire configuration:

   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

3. In `lib/main.dart`, import the generated `firebase_options.dart` and initialize Firebase with:

   ```dart
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   ```

FlutterFire configures the selected platform files/options. Firebase sign-in cannot be tested until this setup is completed. Do not commit private service credentials. Web Firebase configuration is client-side configuration; restrict authorized domains and configure Firebase security rules.

## Run and verify

```bash
dart format .
flutter analyze
flutter test
flutter run -d chrome
```

If Firebase is not configured, the app displays setup guidance and offers guest weather access. A valid OpenWeather key and internet connection are required for live searches.

## Screenshots

No screenshots are included yet. Run the app with valid API configuration, capture the dashboard, city search, weather details, history, login, and registration screens, and save them under `screenshots/`. See [`screenshots/README.md`](screenshots/README.md) for suggested filenames. Do not use mock weather values in submission screenshots.

## Future enhancements

- Add forecast support through OpenWeather's forecast endpoint.
- Use a backend proxy to protect weather API credentials.
- Add Firebase platform configuration and verify end-to-end account flows.
- Add unit and integration tests for API error cases and auth flows.
- Add location-based weather and accessibility refinements.

## GitHub safety

Before pushing, verify `.env` is ignored and no Firebase service credential files are staged. Commit `.env.example`, not `.env`. This project expects the existing `main` branch; review `git status` and remote changes before pushing.
