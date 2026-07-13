import '../../domain/models/destination.dart';
import '../../domain/repositories/destinations_repository.dart';
import '../dummy_destinations.dart';

/// Temporary `DestinationsRepository` backed by the static
/// `dummyDestinations` list. Swap for a real places/geocoding or
/// Firestore-backed source later.
class DummyDestinationsRepository implements DestinationsRepository {
  @override
  Future<List<Destination>> fetchDestinations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return dummyDestinations;
  }
}