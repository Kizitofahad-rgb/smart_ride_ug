import '../models/destination.dart';

/// Contract for fetching searchable destinations. Same reasoning as
/// `RoutesRepository`/`BusStopsRepository`.
abstract class DestinationsRepository {
  Future<List<Destination>> fetchDestinations();
}