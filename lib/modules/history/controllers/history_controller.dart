import 'package:get/get.dart';

import '../../../data/models/weather_model.dart';
import '../../../data/services/search_history_service.dart';

class HistoryController extends GetxController {
  HistoryController({required this.service});

  final SearchHistoryService service;
  final recentWeather = <WeatherModel>[].obs;
  final recentCities = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    reload();
  }

  void reload() {
    recentWeather.assignAll(service.recentWeather);
    recentCities.assignAll(service.recentCities);
  }

  Future<void> addWeather(WeatherModel weather) async {
    await service.addWeather(weather);
    reload();
  }

  Future<void> clear() async {
    await service.clear();
    recentWeather.clear();
    recentCities.clear();
  }
}
