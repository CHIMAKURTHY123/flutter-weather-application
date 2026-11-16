import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:weather_application/data/models/weather_model.dart';
import 'package:weather_application/data/services/search_history_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDirectory;
  late String storageName;
  late GetStorage storage;
  late SearchHistoryService history;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('weather_history_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => tempDirectory.path,
        );
    storageName = 'history_test_${DateTime.now().microsecondsSinceEpoch}';
    storage = GetStorage(storageName, tempDirectory.path);
    await storage.initStorage;
    history = SearchHistoryService(storage: storage);
  });

  tearDown(() async {
    await history.clear();
  });

  test(
    'stores searches, updates duplicates, and retains saved snapshots',
    () async {
      await history.addWeather(_weather('Hyderabad', 31));
      await history.addWeather(_weather('Chennai', 29));
      await history.addWeather(_weather('Hyderabad', 33));

      expect(history.recentCities, ['Hyderabad', 'Chennai']);
      expect(history.recentWeather, hasLength(2));
      expect(history.recentWeather.first.temperature, 33);
      final reopenedHistory = SearchHistoryService(
        storage: GetStorage(storageName, tempDirectory.path),
      );
      // A new service reads through the same GetStorage container after disk flush.
      expect(reopenedHistory.recentCities, ['Hyderabad', 'Chennai']);
    },
  );

  test('clear removes all saved city searches', () async {
    await history.addWeather(_weather('Vijayawada', 30));
    await history.clear();

    expect(history.recentCities, isEmpty);
    expect(history.recentWeather, isEmpty);
  });

  test('parses optional OpenWeather visibility', () {
    final weather = WeatherModel.fromJson({
      'name': 'Bengaluru',
      'sys': {'country': 'IN'},
      'main': {'temp': 26, 'feels_like': 27, 'humidity': 62},
      'wind': {'speed': 3.2},
      'weather': [
        {'description': 'few clouds', 'icon': '02d'},
      ],
      'visibility': 10000,
    });

    expect(weather.visibilityKilometers, 10);
    expect(weather.temperature, 26);
  });
}

WeatherModel _weather(String city, double temperature) => WeatherModel(
  cityName: city,
  countryCode: 'IN',
  temperature: temperature,
  feelsLike: temperature,
  humidity: 60,
  windSpeed: 2.5,
  description: 'clear sky',
  icon: '01d',
  visibilityMeters: 10000,
);
