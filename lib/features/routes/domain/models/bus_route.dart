/// Represents a single passenger bus route.
///
/// Named `BusRoute` rather than `Route` to avoid clashing with
/// Flutter's own `Route` class used for navigation.
///
/// This model is intentionally plain — no Firestore/JSON parsing
/// logic yet. Per ADR-006/ADR-007, backend integration comes after
/// the UI is complete. When Firestore is introduced, a
/// `fromFirestore`/`toFirestore` mapping can be added here without
/// touching any of the widgets that consume this class.
class BusRoute {
  const BusRoute({
    required this.id,
    required this.name,
    required this.origin,
    required this.destination,
    required this.estimatedDuration,
    required this.distanceKm,
    required this.activeBuses,
    required this.stops,
  });

  final String id;
  final String name;
  final String origin;
  final String destination;
  final String estimatedDuration;
  final double distanceKm;
  final int activeBuses;
  final List<String> stops;
}