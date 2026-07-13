import '../domain/models/bus_route.dart';

/// Temporary static data source for routes.
///
/// This is the ONLY file that should need to change when Firestore
/// is introduced (see ADR-004 — `routes` collection). Every widget
/// in this feature consumes `dummyRoutes`, not this list directly,
/// so swapping this out for a repository call later is a one-file
/// change.
final List<BusRoute> dummyRoutes = [
  const BusRoute(
    id: 'route_1',
    name: 'Makerere — City Centre',
    origin: 'Makerere University',
    destination: 'City Centre',
    estimatedDuration: '25 mins',
    distanceKm: 6.5,
    activeBuses: 3,
    stops: [
      'Makerere University',
      'Wandegeya',
      'Bwaise',
      'Kubbiri',
      'City Centre',
    ],
  ),
  const BusRoute(
    id: 'route_2',
    name: 'Wandegeya — Kamwokya',
    origin: 'Wandegeya',
    destination: 'Kamwokya',
    estimatedDuration: '15 mins',
    distanceKm: 3.2,
    activeBuses: 2,
    stops: [
      'Wandegeya',
      'Mulago',
      'Kamwokya',
    ],
  ),
  const BusRoute(
    id: 'route_3',
    name: 'Ntinda — Kireka',
    origin: 'Ntinda',
    destination: 'Kireka',
    estimatedDuration: '20 mins',
    distanceKm: 5.8,
    activeBuses: 1,
    stops: [
      'Ntinda',
      'Kyambogo',
      'Banda',
      'Kireka',
    ],
  ),
  const BusRoute(
    id: 'route_4',
    name: 'Kabalagala — Bugolobi',
    origin: 'Kabalagala',
    destination: 'Bugolobi',
    estimatedDuration: '18 mins',
    distanceKm: 4.1,
    activeBuses: 2,
    stops: [
      'Kabalagala',
      'Kansanga',
      'Muyenga',
      'Bugolobi',
    ],
  ),
];