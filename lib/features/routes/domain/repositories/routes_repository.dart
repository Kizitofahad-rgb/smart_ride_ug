import '../models/bus_route.dart';

/// Contract for fetching routes, independent of where they come from.
///
/// `RoutesBloc` depends on this abstraction, not on
/// `DummyRoutesRepository` directly. When Firestore is introduced
/// (ADR-004), a `FirestoreRoutesRepository` implementing this same
/// interface can be swapped in wherever this is injected — no BLoC
/// or widget code needs to change.
abstract class RoutesRepository {
  Future<List<BusRoute>> fetchRoutes();
}