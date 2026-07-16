import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

/// A transit route, read from the `routes/{routeId}` collection.
///
/// Firestore document shape:
/// ```
/// {
///   "name": "Wandegeya - Makerere",
///   "stopIds": ["stop-old-taxi-park", "stop-wandegeya", "stop-makerere-gate"],
///   "polyline": [
///     { "lat": 0.3136, "lng": 32.5811 },
///     { "lat": 0.3220, "lng": 32.5760 },
///     ...
///   ],
///   "colorHex": "FF38BDF8"
/// }
/// ```
/// [stopIds] is ordered — it's both "which stops are on this route" and the
/// pickup/drop-off sequence. [polyline] is a denser set of points purely for
/// drawing a realistic road-following line; it doesn't have to match
/// [stopIds] 1:1. If a route has no polyline yet, the UI falls back to
/// drawing straight lines between stops.
class BusRoute extends Equatable {
  final String id;
  final String name;
  final List<String> stopIds;
  final List<LatLng> polyline;
  final int colorValue;

  const BusRoute({
    required this.id,
    required this.name,
    required this.stopIds,
    required this.polyline,
    required this.colorValue,
  });

  factory BusRoute.fromFirestore(String id, Map<String, dynamic> data) {
    final rawPolyline = data['polyline'] as List<dynamic>? ?? const [];
    final colorHex = data['colorHex'] as String?;
    return BusRoute(
      id: id,
      name: (data['name'] as String?) ?? 'Unnamed route',
      stopIds: (data['stopIds'] as List<dynamic>?)?.cast<String>() ?? const [],
      polyline: rawPolyline
          .map((p) {
        final m = p as Map<String, dynamic>;
        return LatLng(
          (m['lat'] as num).toDouble(),
          (m['lng'] as num).toDouble(),
        );
      })
          .toList(growable: false),
      colorValue: colorHex != null
          ? int.parse(colorHex, radix: 16)
          : 0xFF38BDF8, // default accent blue
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'stopIds': stopIds,
    'polyline': polyline
        .map((p) => {'lat': p.latitude, 'lng': p.longitude})
        .toList(),
    'colorHex': colorValue.toRadixString(16).toUpperCase(),
  };

  @override
  List<Object?> get props => [id, name, stopIds, polyline, colorValue];
}