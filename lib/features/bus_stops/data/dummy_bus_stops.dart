import '../domain/models/bus_stop.dart';

/// Temporary static data source for bus stops.
///
/// Same pattern as `dummy_routes.dart` — the only file that changes
/// when this is swapped for a Firestore `busStops` query (ADR-004).
final List<BusStop> dummyBusStops = [
  const BusStop(
    id: 'stop_1',
    name: 'Wandegeya',
    distance: '250 m away',
    latitude: 0.3327,
    longitude: 32.5705,
    routesServed: [
      'Makerere — City Centre',
      'Wandegeya — Kamwokya',
    ],
  ),
  const BusStop(
    id: 'stop_2',
    name: 'Mulago',
    distance: '600 m away',
    latitude: 0.3467,
    longitude: 32.5786,
    routesServed: [
      'Wandegeya — Kamwokya',
    ],
  ),
  const BusStop(
    id: 'stop_3',
    name: 'Kamwokya',
    distance: '1.1 km away',
    latitude: 0.3387,
    longitude: 32.5892,
    routesServed: [
      'Wandegeya — Kamwokya',
    ],
  ),
  const BusStop(
    id: 'stop_4',
    name: 'Bwaise',
    distance: '1.4 km away',
    latitude: 0.3505,
    longitude: 32.5560,
    routesServed: [
      'Makerere — City Centre',
    ],
  ),
  const BusStop(
    id: 'stop_5',
    name: 'Ntinda',
    distance: '3.6 km away',
    latitude: 0.3556,
    longitude: 32.6103,
    routesServed: [
      'Ntinda — Kireka',
    ],
  ),
];