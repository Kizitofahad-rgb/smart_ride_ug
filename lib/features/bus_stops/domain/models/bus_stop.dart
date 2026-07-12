/// Represents a single bus stop.
///
/// Same philosophy as `BusRoute`: a plain model with no
/// Firestore-mapping logic yet (ADR-006/ADR-007 — UI before
/// backend). `latitude`/`longitude` are included now even though
/// nothing renders them yet, since ADR-004's `busStops` collection
/// will need coordinates once OpenStreetMap is integrated — adding
/// them later would mean touching every dummy entry again.
class BusStop {
  const BusStop({
    required this.id,
    required this.name,
    required this.distance,
    required this.latitude,
    required this.longitude,
    required this.routesServed,
  });

  final String id;
  final String name;
  final String distance;
  final double latitude;
  final double longitude;
  final List<String> routesServed;
}