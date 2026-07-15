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

  Future<DocumentSnapshot> getUser(String uid) {
    return users.doc(uid).get();
  }

  // --- Booking Methods ---
  Future<String> createBooking(Map<String, dynamic> data) {
    return bookings.add(data).then((doc) => doc.id);
  }

  Stream<QuerySnapshot> getBookingsForUser(String uid) {
    return bookings.where('userId', isEqualTo: uid).snapshots();
  }

  Stream<QuerySnapshot> getPendingBookings() {
    return bookings.where('status', isEqualTo: 'pending').snapshots();
  }

  // 🔥 FIXED: Use Map<String, dynamic> with correct types
  Future<void> updateBookingStatus(String bookingId, String status) async {
    final Map<String, dynamic> data = {'status': status};
    if (status == 'approved') {
      data['approvedAt'] = FieldValue.serverTimestamp();
    }
    return bookings.doc(bookingId).update(data);
  }

  // 🔥 NEW: Smart confirm feature
  Future<void> confirmBooking(String bookingId) {
    return bookings.doc(bookingId).update({
      'confirmed': true,
      'status': 'confirmed',
    });
  }

  // --- Bus Methods ---
  Stream<QuerySnapshot> getActiveBuses() {
    return buses.where('isActive', isEqualTo: true).snapshots();
  }

  Future<void> updateBusLocation(String busId, double lat, double lng) {
    return buses.doc(busId).update({
      'location': GeoPoint(lat, lng),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // --- Trip Methods ---
  Stream<QuerySnapshot> getTripHistory(String userId) {
    return trips
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> createTrip(Map<String, dynamic> data) {
    return trips.add(data);
  }
}
