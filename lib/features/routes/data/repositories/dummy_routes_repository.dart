import '../../domain/models/bus_route.dart';
import '../../domain/repositories/routes_repository.dart';
import '../dummy_routes.dart';

/// Temporary `RoutesRepository` backed by the static `dummyRoutes`
/// list.
///
/// This is the ONLY class that should need to change into
/// `FirestoreRoutesRepository` later (ADR-004 — `routes`
/// collection). The simulated delay lives here rather than in the
/// BLoC, since network latency is a data-layer concern, not a
/// state-management one.
class DummyRoutesRepository implements RoutesRepository {
  @override
  Future<List<BusRoute>> fetchRoutes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return dummyRoutes;
  }
}