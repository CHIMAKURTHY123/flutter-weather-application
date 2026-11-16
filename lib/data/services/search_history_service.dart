import 'package:get_storage/get_storage.dart';

import '../models/weather_model.dart';

class SearchHistoryService {
  SearchHistoryService({GetStorage? storage})
    : _storage = storage ?? GetStorage();

  static const _key = 'weather_search_history';
  static const _limit = 10;
  final GetStorage _storage;

  List<WeatherModel> get recentWeather {
    final values = _storage.read<List<dynamic>>(_key) ?? <dynamic>[];
    final results = <WeatherModel>[];
    for (final value in values) {
      if (value is Map) {
        try {
          results.add(WeatherModel.fromJson(Map<String, dynamic>.from(value)));
        } catch (_) {
          // Skip an invalid entry without losing the other saved searches.
        }
      }
    }
    return results;
  }

  List<String> get recentCities {
    final values = _storage.read<List<dynamic>>(_key) ?? <dynamic>[];
    final seen = <String>{};
    return values
        .map((value) {
          if (value is String) return value;
          if (value is Map && value['name'] is String) {
            return value['name'] as String;
          }
          return null;
        })
        .whereType<String>()
        .where((city) => city.trim().isNotEmpty && seen.add(city.toLowerCase()))
        .toList(growable: false);
  }

  Future<void> addWeather(WeatherModel weather) async {
    final city = weather.cityName.trim();
    if (city.isEmpty) return;
    final nextWeather = <WeatherModel>[
      weather,
      ...recentWeather.where(
        (item) => item.cityName.toLowerCase() != city.toLowerCase(),
      ),
    ];
    final savedCities = nextWeather
        .map((item) => item.cityName.toLowerCase())
        .toSet();
    final oldNames = (_storage.read<List<dynamic>>(_key) ?? <dynamic>[])
        .whereType<String>()
        .where(
          (name) =>
              name.trim().isNotEmpty &&
              !savedCities.contains(name.toLowerCase()),
        )
        .toList(growable: false);
    final next = <dynamic>[
      ...nextWeather.take(_limit).map((item) => item.toJson()),
      ...oldNames,
    ].take(_limit).toList(growable: false);
    await _storage.write(_key, next);
  }

  Future<void> clear() => _storage.remove(_key);
}
