import '../models/bus_stop.dart';

/// Contract for fetching bus stops, independent of where they come
/// from. Same reasoning as `RoutesRepository`.
abstract class BusStopsRepository {
  Future<List<BusStop>> fetchBusStops();
}