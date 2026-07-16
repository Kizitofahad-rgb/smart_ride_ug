import 'package:cloud_firestore/cloud_firestore.dart';

import 'bus_route.dart';
import 'stop.dart';

/// Firestore access for the `routes` and `stops` collections. Mirrors
/// [BusTrackingRepository]'s job for `buses` — one choke point per
/// collection, nothing else in the app talks to Firestore for these.
class RoutesRepository {
  RoutesRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _routes =>
      _firestore.collection('routes');
  CollectionReference<Map<String, dynamic>> get _stops =>
      _firestore.collection('stops');

  /// All stops, live. Small dataset (a city's worth of stops), so the
  /// destination-search screen filters this client-side rather than
  /// running a new Firestore query per keystroke.
  Stream<List<Stop>> watchAllStops() {
    return _stops.snapshots().map(
          (snap) => snap.docs
          .map((d) => Stop.fromFirestore(d.id, d.data()))
          .toList(),
    );
  }

  /// Routes that serve a given stop — i.e. "which buses can get me to the
  /// destination the passenger just picked".
  Stream<List<BusRoute>> watchRoutesServingStop(String stopId) {
    return _routes
        .where('stops_sequence', arrayContains: stopId)
        .snapshots()
        .map((snap) => snap.docs
        .map((d) => BusRoute.fromFirestore(d.id, d.data()))
        .toList());
  }

  /// The ordered list of [Stop]s along a route. `whereIn` caps out at 30
  /// ids per query and rejects duplicate values — loop routes (like E1)
  /// repeat their first stop id at the end, so ids are deduped before the
  /// query and the result is re-expanded back into the route's original
  /// (possibly repeating) order afterward.
  Future<List<Stop>> fetchStopsForRoute(BusRoute route) async {
    if (route.stopIds.isEmpty) return const [];

    final uniqueIds = route.stopIds.toSet().toList(growable: false);
    final byId = <String, Stop>{};
    for (var i = 0; i < uniqueIds.length; i += 30) {
      final chunk = uniqueIds.sublist(
        i,
        i + 30 > uniqueIds.length ? uniqueIds.length : i + 30,
      );
      final snap =
      await _stops.where(FieldPath.documentId, whereIn: chunk).get();
      for (final doc in snap.docs) {
        byId[doc.id] = Stop.fromFirestore(doc.id, doc.data());
      }
    }

    // Re-expand into the route's own stop order — whereIn doesn't preserve
    // it, and a naive dedupe here would break the loop closure.
    return route.stopIds
        .map((id) => byId[id])
        .whereType<Stop>()
        .toList(growable: false);
  }

  /// One-off fetch of every route — used by the driver screen's route
  /// picker, where a live stream would be overkill (routes are admin-curated
  /// and don't change mid-session).
  Future<List<BusRoute>> fetchAllRoutesOnce() async {
    final snapshot = await _routes.get();
    return snapshot.docs
        .map((d) => BusRoute.fromFirestore(d.id, d.data()))
        .toList();
  }

  Future<BusRoute?> fetchRoute(String routeId) async {
    final doc = await _routes.doc(routeId).get();
    final data = doc.data();
    if (!doc.exists || data == null) return null;
    return BusRoute.fromFirestore(doc.id, data);
  }
}