import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

/// A transit route, read from the `routes/{routeId}` collection.
///
/// Firestore document shape (Route E1 seed data):
/// ```
/// {
///   "name": "E1 E-Bus Xpress (Clockwise Loop)",
///   "fare": 1500,
///   "currency": "UGX",
///   "headway_minutes": 15,
///   "stops_sequence": ["stop_city_square", "stop_jinja_road", ..., "stop_city_square"]
/// }
/// ```
/// [stopIds] (backed by the `stops_sequence` field) is ordered — it's both
/// "which stops are on this route" and the pickup/drop-off sequence. Loop
/// routes repeat their first stop id at the end on purpose, to close the
/// loop; that repeat must be preserved, not deduped away.
///
/// [polyline] is an optional denser set of points purely for drawing a
/// realistic road-following line; the E1 seed data doesn't have one yet, so
/// the UI falls back to drawing straight lines between [stopIds] when this
/// is empty (see [RouteLayerManager.buildRoutePolyline]).
class BusRoute extends Equatable {
  final String id;
  final String name;
  final List<String> stopIds;
  final List<LatLng> polyline;
  final int colorValue;
  final int fare;
  final String currency;
  final int headwayMinutes;

  const BusRoute({
    required this.id,
    required this.name,
    required this.stopIds,
    required this.polyline,
    required this.colorValue,
    this.fare = 0,
    this.currency = 'UGX',
    this.headwayMinutes = 0,
  });

  factory BusRoute.fromFirestore(String id, Map<String, dynamic> data) {
    final rawPolyline = data['polyline'] as List<dynamic>? ?? const [];
    final colorHex = data['colorHex'] as String?;
    return BusRoute(
      id: id,
      name: (data['name'] as String?) ?? 'Unnamed route',
      // `stops_sequence` is the real seeded field name; `stopIds` is kept as
      // a fallback for any route docs seeded before this change.
      stopIds: ((data['stops_sequence'] ?? data['stopIds']) as List<dynamic>?)
          ?.cast<String>() ??
          const [],
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
      fare: (data['fare'] as num?)?.toInt() ?? 0,
      currency: (data['currency'] as String?) ?? 'UGX',
      headwayMinutes: (data['headway_minutes'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'stops_sequence': stopIds,
    'polyline': polyline
        .map((p) => {'lat': p.latitude, 'lng': p.longitude})
        .toList(),
    'colorHex': colorValue.toRadixString(16).toUpperCase(),
    'fare': fare,
    'currency': currency,
    'headway_minutes': headwayMinutes,
  };

  String get formattedFare => '$fare $currency';

  String get formattedHeadway => 'Every $headwayMinutes min';

  @override
  List<Object?> get props =>
      [id, name, stopIds, polyline, colorValue, fare, currency, headwayMinutes];
}