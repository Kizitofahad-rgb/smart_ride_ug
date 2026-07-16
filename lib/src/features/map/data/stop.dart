import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

/// A single bus stop, read from the `stops/{stopId}` collection.
///
/// Firestore document shape (Route E1 seed data):
/// ```
/// {
///   "name": "Wandegeya (Makerere Main Gate)",
///   "location": GeoPoint(0.3274, 32.5738)
/// }
/// ```
/// [routeIds] is the many-to-many link back to routes — a stop can sit on
/// more than one route. It's optional seed data, not part of the E1 shape
/// above; it defaults to empty when absent rather than requiring every stop
/// doc to carry it.
class Stop extends Equatable {
  final String id;
  final String name;
  final LatLng position;
  final List<String> routeIds;

  const Stop({
    required this.id,
    required this.name,
    required this.position,
    required this.routeIds,
  });

  factory Stop.fromFirestore(String id, Map<String, dynamic> data) {
    return Stop(
      id: id,
      name: (data['name'] as String?) ?? 'Unnamed stop',
      position: _parsePosition(data),
      routeIds: (data['routeIds'] as List<dynamic>?)?.cast<String>() ?? const [],
    );
  }

  /// Reads `location` as a real Firestore [GeoPoint] (the E1 seed shape),
  /// falling back to the legacy `{lat, lng}` map shape for any stop docs
  /// seeded before this change so nothing already in Firestore breaks.
  static LatLng _parsePosition(Map<String, dynamic> data) {
    final geoPoint = data['location'];
    if (geoPoint is GeoPoint) {
      return LatLng(geoPoint.latitude, geoPoint.longitude);
    }
    final legacy = data['position'] as Map<String, dynamic>?;
    return LatLng(
      (legacy?['lat'] as num?)?.toDouble() ?? 0.0,
      (legacy?['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'location': GeoPoint(position.latitude, position.longitude),
    'routeIds': routeIds,
  };

  @override
  List<Object?> get props => [id, name, position, routeIds];
}