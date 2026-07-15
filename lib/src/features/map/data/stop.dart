import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

/// A single bus stop, read from the `stops/{stopId}` collection.
///
/// Firestore document shape:
/// ```
/// {
///   "name": "Wandegeya Stop",
///   "position": { "lat": 0.3220, "lng": 32.5760 },
///   "routeIds": ["wandegeya-makerere", "kampala-express"]
/// }
/// ```
/// [routeIds] is the many-to-many link back to routes — a stop can sit on
/// more than one route. It's what powers "which routes serve my
/// destination?" (`routes` where `stopIds` array-contains this stop's id
/// works too, but keeping it on both sides means the destination-search
/// screen can resolve routes without a second round trip).
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
    final geo = data['position'] as Map<String, dynamic>?;
    return Stop(
      id: id,
      name: (data['name'] as String?) ?? 'Unnamed stop',
      position: LatLng(
        (geo?['lat'] as num?)?.toDouble() ?? 0.0,
        (geo?['lng'] as num?)?.toDouble() ?? 0.0,
      ),
      routeIds: (data['routeIds'] as List<dynamic>?)?.cast<String>() ?? const [],
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'position': {'lat': position.latitude, 'lng': position.longitude},
    'routeIds': routeIds,
  };

  @override
  List<Object?> get props => [id, name, position, routeIds];
}