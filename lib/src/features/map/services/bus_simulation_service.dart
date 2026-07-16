import 'dart:async';
import 'dart:math'; // 🔥 FIX: For sin, cos, sqrt
import 'package:latlong2/latlong.dart';
import '../models/bus_model.dart';
import '../models/stop_model.dart'; // 🔥 FIX: Import StopModel

class BusSimulationService {
  static final BusSimulationService _instance =
      BusSimulationService._internal();
  factory BusSimulationService() => _instance;
  BusSimulationService._internal();

  // Predefined route coordinates (Kampala loop)
  static final List<LatLng> _routePoints = [
    const LatLng(0.3136, 32.5811), // Old Taxi Park
    const LatLng(0.3180, 32.5780), // City Square
    const LatLng(0.3220, 32.5760), // Wandegeya
    const LatLng(0.3292, 32.5711), // Makerere Main Gate
    const LatLng(0.3340, 32.5675), // CoCIS
    const LatLng(0.3300, 32.5650), // Mulago
    const LatLng(0.3260, 32.5680), // Nakasero
    const LatLng(0.3136, 32.5811), // Back to start
  ];

  static const List<String> _stopNames = [
    'Old Taxi Park',
    'City Square',
    'Wandegeya',
    'Makerere Main Gate',
    'CoCIS',
    'Mulago Hospital',
    'Nakasero',
    'Old Taxi Park',
  ];

  int _currentIndex = 0;
  double _progress = 0.0;
  Timer? _timer;

  Stream<BusModel> simulateBusMovement(String busId, String routeName) {
    return Stream.periodic(const Duration(seconds: 2), (_) {
      _progress += 0.05;
      if (_progress >= 1.0) {
        _progress = 0.0;
        _currentIndex = (_currentIndex + 1) % (_routePoints.length - 1);
      }

      final start = _routePoints[_currentIndex];
      final end = _routePoints[(_currentIndex + 1) % _routePoints.length];

      final lat = start.latitude + (end.latitude - start.latitude) * _progress;
      final lng =
          start.longitude + (end.longitude - start.longitude) * _progress;

      final speed = 20.0 + (DateTime.now().millisecond % 20);
      final passengers = 15 + (DateTime.now().millisecond % 20);
      final totalSeats = 40;

      return BusModel(
        id: busId,
        routeName: routeName,
        position: LatLng(lat, lng),
        speed: speed,
        passengerCount: passengers,
        availableSeats: totalSeats - passengers,
        totalSeats: totalSeats,
        status: 'active',
        lastUpdated: DateTime.now(),
      );
    });
  }

  static StopModel? getNearestStop(LatLng position) {
    double minDistance = double.infinity;
    StopModel? nearest;

    for (int i = 0; i < _routePoints.length; i++) {
      final distance = _distanceBetween(position, _routePoints[i]);
      if (distance < minDistance) {
        minDistance = distance;
        nearest = StopModel(
          id: 'stop_$i',
          name: _stopNames[i],
          position: _routePoints[i],
          routes: ['Kampala Loop'],
        );
      }
    }

    return nearest;
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

  void dispose() {
    _timer?.cancel();
  }
}
