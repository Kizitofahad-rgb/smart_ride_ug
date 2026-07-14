import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

/// Lifecycle states for a tracked bus. Stored in Firestore as the plain
/// string `name` (e.g. "active"), so keep these in sync with whatever the
/// driver screen and Firestore documents use.
enum BusTrackingStatus { idle, active, arrived, offline }

BusTrackingStatus busTrackingStatusFromString(String? value) {
  return BusTrackingStatus.values.firstWhere(
    (s) => s.name == value,
    orElse: () => BusTrackingStatus.idle,
  );
}

/// A single live snapshot of a bus, read straight from its
/// `buses/{busId}` document in Firestore.
class BusLocation extends Equatable {
  final String busId;
  final String routeId;
  final LatLng position;
  final double headingDegrees;
  final double speedKmh;
  final BusTrackingStatus status;
  final DateTime? lastUpdated;

  const BusLocation({
    required this.busId,
    required this.routeId,
    required this.position,
    required this.headingDegrees,
    required this.speedKmh,
    required this.status,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        busId,
        routeId,
        position,
        headingDegrees,
        speedKmh,
        status,
        lastUpdated,
      ];

  factory BusLocation.fromFirestore(String id, Map<String, dynamic> data) {
    final geo = data['position'] as Map<String, dynamic>?;
    final rawTimestamp = data['lastUpdated'];
    return BusLocation(
      busId: id,
      routeId: (data['routeId'] as String?) ?? 'unknown-route',
      position: LatLng(
        (geo?['lat'] as num?)?.toDouble() ?? 0.0,
        (geo?['lng'] as num?)?.toDouble() ?? 0.0,
      ),
      headingDegrees: (data['heading'] as num?)?.toDouble() ?? 0.0,
      speedKmh: (data['speedKmh'] as num?)?.toDouble() ?? 0.0,
      status: busTrackingStatusFromString(data['status'] as String?),
      lastUpdated:
          rawTimestamp is Timestamp ? rawTimestamp.toDate() : null,
    );
  }

  /// True once Firestore hasn't heard from this bus in a while — lets the
  /// UI grey out a marker even if the driver's app crashed without calling
  /// markOffline().
  bool get isStale {
    if (lastUpdated == null) return true;
    return DateTime.now().difference(lastUpdated!) > const Duration(minutes: 2);
  }
}

/// Small distance/ETA helpers shared by the bloc and the driver screen.
class GeoUtils {
  static const Distance _distance = Distance();

  /// Straight-line distance between two points, in meters.
  static double distanceMeters(LatLng a, LatLng b) {
    return _distance.as(LengthUnit.Meter, a, b);
  }

  /// distance / speed, in effect. Buses idling at a stage report ~0 km/h,
  /// which would otherwise make the ETA blow up to infinity, so we fall
  /// back to a conservative average speed whenever the reported speed is
  /// too low to be a useful denominator.
  static Duration estimateArrival({
    required double distanceMeters,
    required double speedKmh,
  }) {
    final effectiveSpeedKmh = speedKmh < 5 ? 15.0 : speedKmh;
    final speedMetersPerSecond = effectiveSpeedKmh * 1000 / 3600;
    final seconds = distanceMeters / speedMetersPerSecond;
    return Duration(seconds: seconds.isFinite ? seconds.round() : 0);
  }
}
