// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../data/models/weather_model.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../history/controllers/history_controller.dart';
import '../../weather/controllers/weather_controller.dart';
import '../../../shared/widgets/weather_metric_card.dart';
import '../../../shared/widgets/weather_summary_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _search = TextEditingController();
  final _weather = Get.find<WeatherController>();
  final _history = Get.find<HistoryController>();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _searchCity() {
    FocusScope.of(context).unfocus();
    return _weather.searchWeather(_search.text);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('SkyCast'),
      actions: [
        IconButton(
          tooltip: 'Search cities',
          onPressed: () => Get.toNamed(AppRoutes.citySearch),
          icon: const Icon(Icons.search_rounded),
        ),
        IconButton(
          tooltip: 'Search history',
          onPressed: () => Get.toNamed(AppRoutes.history),
          icon: const Icon(Icons.history_rounded),
        ),
        if (Get.isRegistered<AuthController>())
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => Get.find<AuthController>().logout(),
            icon: const Icon(Icons.logout_rounded),
          ),
        const SizedBox(width: 8),
      ],
    ),
    body: DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEAF4FF), Color(0xFFF7FAFE), Color(0xFFF4F8FD)],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 760;
                return ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: wide ? 30 : 18,
                    vertical: 20,
                  ),
                  children: [
                    _Greeting(date: DateTime.now()),
                    const SizedBox(height: 22),
                    _SearchBox(
                      controller: _search,
                      isLoading: _weather.isLoading,
                      onSubmit: _searchCity,
                    ),
                    const SizedBox(height: 22),
                    Obx(
                      () => _weather.isLoading.value
                          ? const _LoadingPanel()
                          : _weather.errorMessage.value.isNotEmpty
                          ? _ErrorPanel(message: _weather.errorMessage.value)
                          : _weather.weather.value == null
                          ? const _WelcomePanel()
                          : _WeatherOverview(
                              weather: _weather.weather.value!,
                              wide: wide,
                              onOpenDetails: () =>
                                  Get.toNamed(AppRoutes.weatherDetails),
                            ),
                    ),
                    const SizedBox(height: 26),
                    _RecentCities(
                      history: _history,
                      onSelect: (city) => _weather.searchWeather(city),
                      onViewAll: () => Get.toNamed(AppRoutes.history),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final hour = date.hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
        ? 'Good afternoon'
        : 'Good evening';
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final formattedDate =
        '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.w700,
            color: Color(0xFF20344D),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formattedDate,
          style: const TextStyle(fontSize: 14, color: Color(0xFF718198)),
        ),
      ],
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({
    required this.controller,
    required this.isLoading,
    required this.onSubmit,
  });
  final TextEditingController controller;
  final RxBool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => onSubmit(),
          decoration: InputDecoration(
            hintText: 'Search a city, e.g. Hyderabad',
            prefixIcon: const Icon(Icons.search_rounded),
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 17),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
      Obx(
        () => SizedBox(
          height: 54,
          child: FilledButton.icon(
            onPressed: isLoading.value ? null : onSubmit,
            icon: isLoading.value
                ? const SizedBox(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.search_rounded),
            label: const Text('Search'),
          ),
        ),
      ),
    ],
  );
}

class _WeatherOverview extends StatelessWidget {
  const _WeatherOverview({
    required this.weather,
    required this.wide,
    required this.onOpenDetails,
  });
  final WeatherModel weather;
  final bool wide;
  final VoidCallback onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final summary = WeatherSummaryCard(weather: weather, onTap: onOpenDetails);
    final metrics = LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 540 ? 4 : 2;
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: columns == 4 ? 1.05 : 1.35,
          children: [
            WeatherMetricCard(
              label: 'Feels like',
              value: '${weather.feelsLike.toStringAsFixed(1)}\u00B0C',
              icon: Icons.thermostat_rounded,
            ),
            WeatherMetricCard(
              label: 'Humidity',
              value: '${weather.humidity}%',
              icon: Icons.water_drop_outlined,
            ),
            WeatherMetricCard(
              label: 'Wind speed',
              value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
              icon: Icons.air_rounded,
            ),
            WeatherMetricCard(
              label: 'Visibility',
              value: weather.visibilityKilometers == null
                  ? '—'
                  : '${weather.visibilityKilometers!.toStringAsFixed(1)} km',
              icon: Icons.visibility_outlined,
            ),
          ],
        );
      },
    );
    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: summary),
          const SizedBox(width: 18),
          Expanded(flex: 4, child: metrics),
        ],
      );
    }
    return Column(children: [summary, const SizedBox(height: 12), metrics]);
  }
}

class _RecentCities extends StatelessWidget {
  const _RecentCities({
    required this.history,
    required this.onSelect,
    required this.onViewAll,
  });
  final HistoryController history;
  final ValueChanged<String> onSelect;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) => Obx(() {
    final cities = history.recentWeather;
    if (cities.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Recent cities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF20344D),
                ),
              ),
            ),
            TextButton(onPressed: onViewAll, child: const Text('See all')),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 126,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cities.take(8).length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final city = cities[index];
              return SizedBox(
                width: 184,
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => onSelect(city.cityName),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  city.cityName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  city.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF77869A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (city.iconUrl.isNotEmpty)
                            Image.network(
                              city.iconUrl,
                              width: 44,
                              height: 44,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.cloud_outlined),
                            ),
                          Text(
                            '${city.temperature.toStringAsFixed(0)}°',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  });
}

class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(38),
    child: Center(child: CircularProgressIndicator()),
  );
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Card(
    color: const Color(0xFFFFF3F1),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFC94136)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFF92352D)),
            ),
          ),
        ],
      ),
    ),
  );
}

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel();
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    child: const Padding(
      padding: EdgeInsets.all(24),
      child: Row(
        children: [
          Icon(Icons.wb_cloudy_outlined, color: Color(0xFF3989E8), size: 34),
          SizedBox(width: 14),
          Expanded(
            child: Text('Search for a city to see current weather conditions.'),
          ),
        ],
      ),
    ),
  );
}
