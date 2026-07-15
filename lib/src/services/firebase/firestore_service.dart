import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get users => _db.collection('users');
  CollectionReference get bookings => _db.collection('bookings');
  CollectionReference get buses => _db.collection('buses');
  CollectionReference get trips => _db.collection('trips');

  // --- User Methods ---
  Future<void> createUser(String uid, Map<String, dynamic> data) {
    return users.doc(uid).set(data);
  }

  // --- Booking Methods (For Mable & Mutebi) ---
  Future<String> createBooking(Map<String, dynamic> data) {
    return bookings.add(data).then((doc) => doc.id);
  }

  Stream<QuerySnapshot> getBookingsForUser(String uid) {
    return bookings.where('userId', isEqualTo: uid).snapshots();
  }

  Stream<QuerySnapshot> getPendingBookings() {
    return bookings.where('status', isEqualTo: 'pending').snapshots();
  }

  Future<void> updateBookingStatus(String bookingId, String status) {
    return bookings.doc(bookingId).update({'status': status});
  }

  // --- Bus Methods (For Faisal) ---
  Stream<QuerySnapshot> getActiveBuses() {
    return buses.where('isActive', isEqualTo: true).snapshots();
  }

  Future<void> updateBusLocation(String busId, double lat, double lng) {
    return buses.doc(busId).update({
      'location': GeoPoint(lat, lng),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // --- Trip Methods (For Mable) ---
  Stream<QuerySnapshot> getTripHistory(String userId) {
    return trips
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future<void> createTrip(Map<String, dynamic> data) {
    return trips.add(data);
  }
}
