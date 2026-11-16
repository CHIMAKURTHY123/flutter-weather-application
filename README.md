# SkyCast - Flutter Weather Application

SkyCast is a Flutter weather app for searching live current conditions by city. It also saves recent searches locally. Firebase email/password accounts are available after platform configuration is added.

## Features

- Current weather from OpenWeather by city.
- Celsius temperature, weather condition and icon, feels-like temperature, humidity, wind speed, and visibility when the API includes it.
- Responsive dashboard, city search, current-weather details, and recent-search screens.
- Loading states and readable messages for empty input, invalid city/key, rate limits, timeouts, and connection errors.
- GetStorage search history with recent-first ordering, duplicate updates, persisted weather snapshots, and clear-history confirmation.
- Firebase registration, login, session restoration, guarded weather routes, and logout when Firebase is configured.
- Guest weather mode when Firebase is not configured.

The app uses OpenWeather's current `/weather` endpoint. It does not provide hourly forecasts, so this version does not show a forecast.

## Technologies

- Flutter 3.50 and Dart 3.14
- GetX for state management, bindings, and navigation
- Dio for HTTP requests
- OpenWeather current weather API
- GetStorage for local search history
- Firebase Core and Firebase Authentication
- `flutter_dotenv` for local environment configuration

## Architecture

```text
lib/
|-- main.dart
|-- core/
|   |-- bindings/       # App-wide GetX dependency registration
|   |-- constants/      # API endpoint and configuration names
|   |-- routes/         # Routes and auth middleware
|   `-- theme/          # Shared visual theme
|-- data/
|   |-- models/         # Weather response model
|   |-- providers/      # Dio/OpenWeather requests
|   |-- repositories/   # Provider-to-model boundary
|   `-- services/       # Firebase auth and local search history
|-- modules/
|   |-- auth/           # Login, registration, and validation
|   |-- dashboard/      # Dashboard and city search
|   |-- history/        # History controller and screen
|   `-- weather/        # Weather controller and details
`-- shared/widgets/     # Reusable auth and weather cards
```

The provider makes HTTP requests, the repository converts responses into a model, and GetX controllers expose data and states to the screens.

## Requirements

- Flutter 3.50 or a compatible Flutter/Dart version.
- An OpenWeather API key for live weather.
- A Firebase project for account features.

## Install and run

1. Clone the repository and open its folder.
2. Copy `.env.example` to `.env`, then add your OpenWeather key and preferred default city.
3. Run:

   ```bash
   flutter pub get
   dart format .
   flutter analyze
   flutter test
   flutter run -d chrome
   ```

Do not replace an existing local `.env` unless you have saved its values elsewhere.

## OpenWeather setup

The local `.env` file should contain:

```env
OPENWEATHER_API_KEY=your_key_here
DEFAULT_CITY=London
```

`.env` is ignored by Git. Flutter bundles declared assets into the client app, so the key can still be extracted from a web or mobile build. Use a backend proxy for production and rotate any key that has been exposed.

## Firebase setup

1. Create a Firebase project and enable **Authentication > Sign-in method > Email/Password**.
2. Install and run FlutterFire configuration:

   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

3. Import the generated `firebase_options.dart` in `lib/main.dart` and initialize Firebase with:

   ```dart
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   ```

Firebase authentication has not been integration-tested until this setup is complete. Keep private service credentials out of Git. Web Firebase configuration is client-side configuration; restrict authorized domains and configure Firebase security rules.

## Screenshots

No screenshots are included yet. Capture genuine app screenshots with live weather data and save them under `screenshots/`. Suggested screens and file names are listed in [`screenshots/README.md`](screenshots/README.md). Do not include API keys or personal account details.

## Testing

The test suite covers auth input validation, route access for guest mode, weather response parsing, Dio error mapping, history duplicate updates and clearing, and dashboard/search navigation. Live API requests require a valid local key and internet access. Firebase account flows require Firebase configuration.

## Future enhancements

- Add forecast data through OpenWeather's forecast endpoint.
- Use a backend proxy to protect the API key in production.
- Configure Firebase per target platform and add auth integration tests.
- Add location-based weather and accessibility improvements.

## GitHub safety

The `.gitignore` excludes `.env`, `google-services.json`, and `GoogleService-Info.plist`. Before pushing, review `git status` and confirm private configuration files are not staged. Commit `.env.example`, not `.env`.
