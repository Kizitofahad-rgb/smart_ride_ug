import 'package:flutter/material.dart';

class MapThemeService {
  // Dark tile URL for OpenStreetMap (CartoDB Dark)
  static const String darkTileUrl =
      'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png';

  // Light tile URL (fallback)
  static const String lightTileUrl =
      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';

  // Get dark theme map options
  static Map<String, dynamic> getDarkThemeOptions() {
    return {
      'urlTemplate': darkTileUrl,
      'subdomains': ['a', 'b', 'c', 'd'],
      'maxZoom': 20,
      'userAgentPackageName': 'com.mhl.smart_ride_ug',
    };
  }

  // Map colors (for polyline, markers)
  static const Color routeColor = Color(0xFF2563EB); // Blue
  static const Color startMarkerColor = Color(0xFF10B981); // Green
  static const Color endMarkerColor = Color(0xFFEF4444); // Red
  static const Color stopMarkerColor = Color(0xFF64748B); // Grey
  static const Color busMarkerColor = Color(0xFF2563EB); // Blue
}
