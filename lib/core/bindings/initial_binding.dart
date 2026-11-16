import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../data/providers/weather_provider.dart';
import '../../data/repositories/weather_repository.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/search_history_service.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../../modules/history/controllers/history_controller.dart';
import '../../modules/weather/controllers/weather_controller.dart';

class InitialBinding extends Bindings {
  InitialBinding({required this.firebaseReady});

  final bool firebaseReady;

  @override
  void dependencies() {
    Get.put<Dio>(Dio(), permanent: true);
    Get.put(WeatherProvider(Get.find<Dio>()), permanent: true);
    Get.put(WeatherRepository(Get.find<WeatherProvider>()), permanent: true);
    Get.put(SearchHistoryService(), permanent: true);
    Get.put(
      HistoryController(service: Get.find<SearchHistoryService>()),
      permanent: true,
    );
    Get.put(
      WeatherController(
        repository: Get.find<WeatherRepository>(),
        historyController: Get.find<HistoryController>(),
      ),
      permanent: true,
    );
    if (firebaseReady) {
      Get.put(AuthController(service: AuthService()), permanent: true);
    }
  }
}
