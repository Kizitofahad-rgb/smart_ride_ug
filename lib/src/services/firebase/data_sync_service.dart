import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

class DataSyncService {
  static final DataSyncService _instance = DataSyncService._internal();
  factory DataSyncService() => _instance;
  DataSyncService._internal();

  final FirestoreService _firestore = FirestoreService();

  // For Faisal: Sync active buses
  Stream<List<Map<String, dynamic>>> syncActiveBuses() {
    return _firestore.getActiveBuses().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();
    });
  }

  // For Mable: Sync bookings for a user
  Stream<List<Map<String, dynamic>>> syncBookingsForUser(String userId) {
    return _firestore.getBookingsForUser(userId).map((snapshot) {
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();
    });
  }

  // For Mutebi: Sync pending bookings
  Stream<List<Map<String, dynamic>>> syncPendingBookings() {
    return _firestore.getPendingBookings().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();
    });
  }

  // For Mable: Sync trip history
  Stream<List<Map<String, dynamic>>> syncTripHistory(String userId) {
    return _firestore.getTripHistory(userId).map((snapshot) {
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();
    });
  }
}
