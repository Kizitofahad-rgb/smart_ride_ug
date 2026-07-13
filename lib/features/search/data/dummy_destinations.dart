import '../domain/models/destination.dart';

/// Temporary static list of searchable destinations.
///
/// Same pattern as `dummy_routes.dart` and `dummy_bus_stops.dart` —
/// the only file that changes once destinations are backed by
/// Firestore or a proper places/geocoding source.
final List<Destination> dummyDestinations = [
  const Destination(id: 'dest_1', name: 'Makerere University', area: 'Kawempe'),
  const Destination(id: 'dest_2', name: 'Wandegeya', area: 'Kawempe'),
  const Destination(id: 'dest_3', name: 'Mulago', area: 'Kawempe'),
  const Destination(id: 'dest_4', name: 'Kamwokya', area: 'Central'),
  const Destination(id: 'dest_5', name: 'City Centre', area: 'Central'),
  const Destination(id: 'dest_6', name: 'Bwaise', area: 'Kawempe'),
  const Destination(id: 'dest_7', name: 'Ntinda', area: 'Nakawa'),
  const Destination(id: 'dest_8', name: 'Kireka', area: 'Nakawa'),
  const Destination(id: 'dest_9', name: 'Kabalagala', area: 'Makindye'),
  const Destination(id: 'dest_10', name: 'Bugolobi', area: 'Nakawa'),
];