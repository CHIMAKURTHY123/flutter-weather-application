// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../shared/widgets/weather_summary_card.dart';
import '../../history/controllers/history_controller.dart';
import '../../weather/controllers/weather_controller.dart';

class CitySearchScreen extends StatefulWidget {
  const CitySearchScreen({super.key});

  @override
  State<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  final _search = TextEditingController();
  final _weather = Get.find<WeatherController>();
  final _history = Get.find<HistoryController>();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    await _weather.searchWeather(_search.text, openResult: false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Search cities')),
    body: DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEAF4FF), Color(0xFFF7FAFE)],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Find a city',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF20344D),
                  ),
                ),
                const SizedBox(height: 6),
                const Text('Search current conditions by city name.'),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _search,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          hintText: 'e.g. Vijayawada, Hyderabad, Chennai',
                          prefixIcon: const Icon(Icons.search_rounded),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => FilledButton(
                        onPressed: _weather.isLoading.value ? null : _submit,
                        child: _weather.isLoading.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Search'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Obx(() {
                  if (_weather.isLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(28),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (_weather.errorMessage.value.isNotEmpty) {
                    return Card(
                      color: const Color(0xFFFFF3F1),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _weather.errorMessage.value,
                          style: const TextStyle(color: Color(0xFF92352D)),
                        ),
                      ),
                    );
                  }
                  final weather = _weather.weather.value;
                  if (weather == null) return const SizedBox.shrink();
                  return Column(
                    children: [
                      WeatherSummaryCard(
                        weather: weather,
                        compact: true,
                        onTap: () => Get.toNamed(AppRoutes.weatherDetails),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () =>
                              Get.toNamed(AppRoutes.weatherDetails),
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('View weather details'),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Recent searches',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF20344D),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.history),
                      child: const Text('Manage'),
                    ),
                  ],
                ),
                Obx(() {
                  if (_history.recentCities.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'Your successful city searches will appear here.',
                      ),
                    );
                  }
                  return Column(
                    children: _history.recentCities.map((name) {
                      final snapshot = _history.recentWeather.firstWhereOrNull(
                        (item) =>
                            item.cityName.toLowerCase() == name.toLowerCase(),
                      );
                      return Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ListTile(
                          onTap: () async {
                            _search.text = name;
                            await _weather.searchWeather(
                              name,
                              openResult: false,
                            );
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
                          title: Text(snapshot?.displayLocation ?? name),
                          subtitle: Text(
                            snapshot?.description ??
                                'Tap to check current weather',
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
                    }).toList(),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
