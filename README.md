# Flutter Weather Application

A Flutter weather app built with GetX, Dio, GetStorage, `flutter_dotenv`, and Firebase Authentication.

## Requirements

- Flutter 3.50.0 / Dart 3.14.0 or compatible versions.
- An OpenWeather API key.
- A Firebase project with Email/Password sign-in enabled for authentication.

## Local setup

1. Copy `.env.example` to `.env` and replace `YOUR_OPENWEATHER_API_KEY` with your own key. `.env` is ignored by Git.
2. Run `flutter pub get`.
3. To configure authentication and Chrome, create a Firebase project, enable Email/Password in Authentication, register a Web app, then run `dart pub global activate flutterfire_cli` and `flutterfire configure`. Add Firebase options initialization using the generated `firebase_options.dart` before `Firebase.initializeApp()` in `lib/main.dart`.
4. Run `flutter run -d chrome`.

The app starts on a Firebase setup screen if Firebase has not been configured; you can continue to weather search as a guest. Sign in and registration require valid Firebase platform configuration. Firebase configuration is not included in this repository.

## Features

- Responsive blue-gradient dashboard with greeting, date, current conditions, weather icon, and metric cards.
- City search screen and separate current-weather details screen.
- Celsius temperature, feels-like temperature, humidity, wind speed, and visibility when OpenWeather includes it.
- Loading, invalid city, invalid key, timeout, and connection error states.
- Firebase email/password registration and login with persistent Firebase sessions, once configured.
- Recent successful searches stored locally with duplicate cities removed, weather snapshots, and a clear-history action.

The configured `/weather` endpoint returns current conditions. It does not provide hourly forecasts, so the app does not show a fabricated forecast.

## API key note

`.env` is excluded from Git, but Flutter assets are packaged into the client application. A key used by a distributed mobile or web app can be extracted. Restrict the OpenWeather key where possible, rotate any key that was exposed, and use a backend proxy for production.

## GitHub submission

Before publishing, check that `.env` and Firebase service credentials are not staged. Commit `.env.example`, source code, this README, and screenshots. Do not commit `android/app/google-services.json`, iOS `GoogleService-Info.plist`, or private signing files. Firebase web configuration is client configuration, but apply Firebase Auth domain restrictions and security rules.
