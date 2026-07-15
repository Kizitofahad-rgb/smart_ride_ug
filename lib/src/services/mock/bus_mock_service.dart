import 'dart:async';
import 'package:latlong2/latlong.dart';

class BusMockService {
  static final List<LatLng> _routePoints = [
    const LatLng(0.3136, 32.5811), // Kampala Central
    const LatLng(0.3220, 32.5760), // Wandegeya
    const LatLng(0.3292, 32.5711), // Makerere Main Gate
    const LatLng(0.3340, 32.5675), // CoCIS
  ];

  static Stream<LatLng> simulateBusMovement() {
    int index = 0;
    return Stream.periodic(const Duration(seconds: 2), (_) {
      index = (index + 1) % _routePoints.length;
      return _routePoints[index];
    });
  }

  static Stream<int> simulatePassengerCount() {
    int count = 15;
    return Stream.periodic(const Duration(seconds: 3), (_) {
      count += (count > 12 && count < 25) ? (1 - 2 * (count % 2)) : 0;
      return count.clamp(12, 25);
    });
  }
}
