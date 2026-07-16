import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import '../models/bus_model.dart';

class BusRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<BusModel>> getActiveBuses() {
    return _firestore
        .collection('buses')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            // 🔥 FIX: Use doc.data()! to assert non-null
            return BusModel.fromFirestore(doc.id, doc.data()!);
          }).toList();
        });
  }

  Stream<BusModel?> getBus(String busId) {
    return _firestore.collection('buses').doc(busId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return BusModel.fromFirestore(doc.id, doc.data()!);
    });
  }

  Future<void> updateBusLocation({
    required String busId,
    required LatLng position,
    required double speed,
    required int passengerCount,
    required int availableSeats,
  }) {
    return _firestore.collection('buses').doc(busId).update({
      'location': GeoPoint(position.latitude, position.longitude),
      'speed': speed,
      'passengerCount': passengerCount,
      'availableSeats': availableSeats,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addBus(BusModel bus) {
    return _firestore.collection('buses').doc(bus.id).set(bus.toFirestore());
  }

  Future<void> deactivateBus(String busId) {
    return _firestore.collection('buses').doc(busId).update({
      'isActive': false,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }
}
