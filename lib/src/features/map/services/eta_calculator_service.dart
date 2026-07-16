import 'dart:math'; // 🔥 FIX: For sin, cos, sqrt
import 'package:latlong2/latlong.dart';

class ETACalculatorService {
  static const double _averageSpeedKmh = 25.0;

  static int calculateETA(LatLng start, LatLng end) {
    final distance = _distanceBetween(start, end);
    final timeMinutes = (distance / 1000) / _averageSpeedKmh * 60;
    return timeMinutes.ceil();
  }

  static double _distanceBetween(LatLng p1, LatLng p2) {
    // 🔥 FIX: Use dart:math functions
    const double earthRadius = 6371000;
    final dLat = (p2.latitude - p1.latitude) * pi / 180;
    final dLon = (p2.longitude - p1.longitude) * pi / 180;
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(p1.latitude * pi / 180) *
            cos(p2.latitude * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  static int getETAtoNearestStop(LatLng busPosition, List<LatLng> stops) {
    double minDistance = double.infinity;
    for (final stop in stops) {
      final dist = _distanceBetween(busPosition, stop);
      if (dist < minDistance) minDistance = dist;
    }
    return (minDistance / 1000 / _averageSpeedKmh * 60).ceil();
  }
}
