import 'dart:async';
import 'package:latlong2/latlong.dart';

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
  Stream<BusTelemetryMetrics> poolBusMetrics(String TargetBusId) async* {
    // Simulating precise linear vehicle transitions traversing Wandegeya coordinates
    final pathPoints = [
      LatLng(0.3220, 32.5760),
      LatLng(0.3245, 32.5745),
      LatLng(0.3270, 32.5728),
      LatLng(0.3292, 32.5711),
    ];

    int executionIndex = 0;

    while (true) {
      await Future.delayed(const Duration(seconds: 3));
      final activePoint = pathPoints[executionIndex % pathPoints.length];
      executionIndex++;

      yield BusTelemetryMetrics(
        busId: TargetBusId,
        currentPosition: activePoint,
        speedKmh: 35.0 + (executionIndex % 3) * 4.2,
        passengerCount: 18 + (executionIndex % 2),
      );
    }
  }
}