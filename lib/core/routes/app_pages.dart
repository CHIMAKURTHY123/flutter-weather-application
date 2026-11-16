import 'package:get/get.dart';

import '../../modules/auth/views/auth_gate_screen.dart';
import '../../modules/auth/views/login_screen.dart';
import '../../modules/auth/views/register_screen.dart';
import '../../modules/dashboard/views/dashboard_screen.dart';
import '../../modules/dashboard/views/city_search_screen.dart';
import '../../modules/history/views/history_screen.dart';
import '../../modules/weather/views/weather_details_screen.dart';
import '../../shared/widgets/firebase_setup_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.authGate, page: () => const AuthGateScreen()),
    GetPage(
      name: AppRoutes.firebaseSetup,
      page: () => const FirebaseSetupScreen(),
    ),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
    GetPage(name: AppRoutes.dashboard, page: () => const DashboardScreen()),
    GetPage(name: AppRoutes.citySearch, page: () => const CitySearchScreen()),
    GetPage(
      name: AppRoutes.weatherDetails,
      page: () => const WeatherDetailsScreen(),
    ),
    GetPage(name: AppRoutes.history, page: () => const HistoryScreen()),
  ];
}
