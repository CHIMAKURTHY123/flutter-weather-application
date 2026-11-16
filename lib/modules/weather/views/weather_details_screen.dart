// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/weather_controller.dart';

class WeatherDetailsScreen extends GetView<WeatherController> {
  const WeatherDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Weather details')),
    body: Obx(() {
      final weather = controller.weather.value;
      if (weather == null) {
        return Center(
          child: Text(
            controller.errorMessage.value.isEmpty
                ? 'Search for a city to view current weather.'
                : controller.errorMessage.value,
          ),
        );
      }
      return DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAF4FF), Color(0xFFF7FAFE)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  weather.displayLocation,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF20344D),
                  ),
                ),
                const SizedBox(height: 12),
                if (weather.iconUrl.isNotEmpty)
                  Image.network(
                    weather.iconUrl,
                    width: 120,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.cloud_outlined,
                      size: 88,
                      color: Color(0xFF3989E8),
                    ),
                  ),
                Text(
                  '${weather.temperature.toStringAsFixed(1)}\u00B0C',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF20344D),
                  ),
                ),
                Text(
                  weather.description.capitalizeFirst ?? weather.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFF718198),
                  ),
                ),
                const SizedBox(height: 20),
                _detail(
                  'Feels like',
                  '${weather.feelsLike.toStringAsFixed(1)}\u00B0C',
                  Icons.thermostat_rounded,
                ),
                _detail(
                  'Humidity',
                  '${weather.humidity}%',
                  Icons.water_drop_outlined,
                ),
                _detail(
                  'Wind speed',
                  '${weather.windSpeed.toStringAsFixed(1)} m/s',
                  Icons.air_rounded,
                ),
                if (weather.visibilityKilometers != null)
                  _detail(
                    'Visibility',
                    '${weather.visibilityKilometers!.toStringAsFixed(1)} km',
                    Icons.visibility_outlined,
                  ),
                const SizedBox(height: 8),
                const Text(
                  'Hourly forecast is not included in the current-weather endpoint.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Color(0xFF718198)),
                ),
              ],
            ),
          ),
        ),
      );
    }),
  );

  Widget _detail(String label, String value, IconData icon) => Card(
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
    child: ListTile(
      leading: Icon(icon, color: const Color(0xFF397DD2)),
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );
}
