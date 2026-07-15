import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

import 'bus_location.dart';

/// The single choke point for talking to the `buses` collection in
/// Firestore. Both the passenger-facing LiveMapBloc and the driver
/// broadcast screen go through this — neither touches Firestore directly.
///
/// Firestore document shape (`buses/{busId}`):
/// ```
/// {
///   "routeId": "wandegeya-makerere",
///   "position": { "lat": 0.3292, "lng": 32.5711 },
///   "heading": 87.5,
///   "speedKmh": 32.0,
///   "status": "active",           // idle | active | arrived | offline
///   "lastUpdated": <server timestamp>
/// }
/// ```
class BusTrackingRepository {
  BusTrackingRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _buses =>
      _firestore.collection('buses');

  /// Live stream of a single bus's position/status. Emits `null` if the
  /// document doesn't exist yet (e.g. the driver hasn't started a trip).
  Stream<BusLocation?> watchBus(String busId) {
    return _buses.doc(busId).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (!snapshot.exists || data == null) return null;
      return BusLocation.fromFirestore(snapshot.id, data);
    });
  }

  /// Called by the driver screen every time a new GPS fix comes in.
  Future<void> pushLocation({
    required String busId,
    required String routeId,
    required LatLng position,
    required double headingDegrees,
    required double speedKmh,
    required BusTrackingStatus status,
  }) {
    return _buses.doc(busId).set({
      'routeId': routeId,
      'position': {'lat': position.latitude, 'lng': position.longitude},
      'heading': headingDegrees,
      'speedKmh': speedKmh,
      'status': status.name,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Marks the bus offline when the driver ends their trip, so passengers
  /// don't keep watching a stale marker on the map.
  Future<void> markOffline(String busId) {
    return _buses.doc(busId).set({
      'status': BusTrackingStatus.offline.name,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
