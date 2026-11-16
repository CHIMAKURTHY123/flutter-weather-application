// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../history/controllers/history_controller.dart';
import '../../weather/controllers/weather_controller.dart';

class HistoryScreen extends GetView<HistoryController> {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Recent searches'),
      actions: [
        Obx(
          () => TextButton(
            onPressed: controller.recentCities.isEmpty
                ? null
                : () => _confirmClear(context),
            child: const Text('Clear'),
          ),
        ),
      ],
    ),
    body: Obx(() {
      if (controller.recentCities.isEmpty) {
        return const Center(child: Text('No recent searches yet.'));
      }
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.recentCities.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final city = controller.recentCities[index];
              final snapshot = controller.recentWeather.firstWhereOrNull(
                (item) => item.cityName.toLowerCase() == city.toLowerCase(),
              );
              return Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ListTile(
                  onTap: () async {
                    final success = await Get.find<WeatherController>()
                        .searchWeather(city, openResult: false);
                    if (success) Get.toNamed(AppRoutes.weatherDetails);
                  },
                  leading: snapshot == null || snapshot.iconUrl.isEmpty
                      ? const Icon(
                          Icons.location_city,
                          color: Color(0xFF3989E8),
                        )
                      : Image.network(
                          snapshot.iconUrl,
                          width: 42,
                          height: 42,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.cloud_outlined),
                        ),
                  title: Text(snapshot?.displayLocation ?? city),
                  subtitle: Text(
                    snapshot?.description ?? 'Tap to check current weather',
                  ),
                  trailing: snapshot == null
                      ? const Icon(Icons.chevron_right)
                      : Text(
                          '${snapshot.temperature.toStringAsFixed(0)}\u00B0C',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      );
    }),
  );

  Future<void> _confirmClear(BuildContext context) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Clear search history?'),
        content: const Text(
          'This removes all saved city searches from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Clear history'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    if (confirmed == true) await controller.clear();
  }
}
