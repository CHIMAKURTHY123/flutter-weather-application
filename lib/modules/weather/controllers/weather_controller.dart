import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../../../core/constants/api_constants.dart';
import '../../../data/models/weather_model.dart';
import '../../../data/providers/weather_provider.dart';
import '../../../data/repositories/weather_repository.dart';
import '../../history/controllers/history_controller.dart';

class WeatherController extends GetxController {
  WeatherController({
    required this.repository,
    required this.historyController,
  });
  final WeatherRepository repository;
  final HistoryController historyController;

  final weather = Rxn<WeatherModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final searchedCity = ''.obs;
  int _requestId = 0;

  @override
  void onInit() {
    super.onInit();
    final defaultCity = dotenv.env['DEFAULT_CITY']?.trim();
    if (defaultCity != null && defaultCity.isNotEmpty) {
      searchWeather(defaultCity, openResult: false);
    }
  }

  Future<bool> searchWeather(String city, {bool openResult = true}) async {
    final cityName = city.trim();
    if (cityName.isEmpty) {
      errorMessage.value = 'Enter a city name to search.';
      return false;
    }
    final key = dotenv.env[ApiConstants.apiKeyEnvironmentVariable]?.trim();
    if (key == null || key.isEmpty || key == 'YOUR_OPENWEATHER_API_KEY') {
      errorMessage.value =
          'Add your OpenWeather API key to the local .env file.';
      return false;
    }

    final requestId = ++_requestId;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await repository.getWeather(cityName, key);
      if (requestId != _requestId) return false;
      weather.value = result;
      searchedCity.value = result.cityName;
      try {
        await historyController.addWeather(result);
      } catch (_) {
        // A local history write must not discard a successful live weather result.
      }
      if (openResult && Get.currentRoute != '/weather-details') {
        Get.toNamed('/weather-details');
      }
      return true;
    } catch (error) {
      if (requestId == _requestId) {
        weather.value = null;
        errorMessage.value = error is WeatherApiException
            ? error.message
            : 'Something went wrong while loading weather. Please try again.';
      }
      return false;
    } finally {
      if (requestId == _requestId) isLoading.value = false;
    }
  }

  Future<bool> refreshWeather() {
    final city = searchedCity.value;
    if (city.isEmpty) {
      errorMessage.value = 'Search for a city before refreshing weather.';
      return Future.value(false);
    }
    return searchWeather(city, openResult: false);
  }

  Future<void> clearHistory() async {
    await historyController.clear();
  }
}
