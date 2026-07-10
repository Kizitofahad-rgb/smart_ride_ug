import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusTelemetryMetrics {
  final String busId;
  final LatLng currentPosition;
  final double speedKmh;
  final int passengerCount;

  BusTelemetryMetrics({
    required this.busId,
    required this.currentPosition,
    required this.speedKmh,
    required this.passengerCount,
  });
}

class BusTelemetryPoller {
  Stream<BusTelemetryMetrics> poolBusMetrics(String targetBusId) async* {
    // Simulating precise linear vehicle transitions traversing Wandegeya coordinates
    final pathPoints = [
      const LatLng(0.3220, 32.5760),
      const LatLng(0.3245, 32.5745),
      const LatLng(0.3270, 32.5728),
      const LatLng(0.3292, 32.5711),
    ];

    int executionIndex = 0;

    while (true) {
      await Future.delayed(const Duration(seconds: 3));
      final activePoint = pathPoints[executionIndex % pathPoints.length];
      executionIndex++;

      yield BusTelemetryMetrics(
        busId: targetBusId,
        currentPosition: activePoint,
        speedKmh: 35.0 + (executionIndex % 3) * 4.2,
        passengerCount: 18 + (executionIndex % 2),
      );
    }
  }
}