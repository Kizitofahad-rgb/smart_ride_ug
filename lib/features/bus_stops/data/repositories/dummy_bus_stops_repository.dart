import '../../domain/models/bus_stop.dart';
import '../../domain/repositories/bus_stops_repository.dart';
import '../dummy_bus_stops.dart';

/// Temporary `BusStopsRepository` backed by the static
/// `dummyBusStops` list. Swap for `FirestoreBusStopsRepository`
/// later (ADR-004 — `busStops` collection).
class DummyBusStopsRepository implements BusStopsRepository {
  @override
  Future<List<BusStop>> fetchBusStops() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return dummyBusStops;
  }
}