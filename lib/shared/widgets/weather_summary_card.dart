// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/weather_model.dart';

class WeatherSummaryCard extends StatelessWidget {
  const WeatherSummaryCard({
    required this.weather,
    required this.onTap,
    this.compact = false,
    super.key,
  });

  final WeatherModel weather;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final iconSize = compact ? 76.0 : 118.0;
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3989E8), Color(0xFF1456AE)],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(compact ? 20 : 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        weather.displayLocation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white70),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${weather.temperature.toStringAsFixed(0)}\u00B0C',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: compact ? 54 : 72,
                              height: 1,
                              fontWeight: FontWeight.w300,
                              letterSpacing: -2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            weather.description.capitalizeFirst ??
                                weather.description,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Feels like ${weather.feelsLike.toStringAsFixed(0)}\u00B0C',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: weather.iconUrl.isEmpty
                          ? const Icon(
                              Icons.cloud,
                              color: Colors.white,
                              size: 66,
                            )
                          : Image.network(
                              weather.iconUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.cloud,
                                    color: Colors.white,
                                    size: 66,
                                  ),
                            ),
                    ),
                  ],
                ),
                if (!compact) ...[
                  const SizedBox(height: 14),
                  const Text(
                    'Tap to see full weather details',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
