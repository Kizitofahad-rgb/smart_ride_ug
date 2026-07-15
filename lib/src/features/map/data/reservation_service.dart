import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../services/firebase/firestore_service.dart';

/// The map feature's hook into the shared `bookings` collection
/// ([FirestoreService.bookings], "For Mable & Mutebi" per the original
/// comment). This is intentionally the *only* place map/route code talks to
/// bookings — everything else (seat selection, payment, operator approval)
/// stays in Mable's `BookingScreen` and Mutebi's operator dashboard.
///
/// A reservation created here shows up in:
/// - `FirestoreService.getBookingsForUser(uid)` — passenger's trip history
/// - `FirestoreService.getPendingBookings()` — operator dashboard queue
///
/// Mable's screen only needs to add whatever seat/payment fields it wants
/// on top of the same document (e.g. `.update()` after `createReservation`
/// returns the booking id) — the routeId/pickupStopId/destinationStopId
/// fields below are additive, not a replacement for her existing schema.
class ReservationService {
  ReservationService({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;

  /// Creates a pending reservation for a passenger picking up a bus at
  /// [pickupStopId] (normally their nearest stop) heading to
  /// [destinationStopId] on [routeId]. If a specific bus is already live on
  /// the route, pass its id as [busId] so operators/drivers see which bus
  /// was reserved against; leave it null if the passenger reserved before
  /// any bus started broadcasting.
  ///
  /// Returns the new booking's Firestore document id.
  Future<String> createReservation({
    required String userId,
    required String routeId,
    required String routeName,
    required String pickupStopId,
    required String pickupStopName,
    required String destinationStopId,
    required String destinationStopName,
    String? busId,
  }) {
    return _firestoreService.createBooking({
      'userId': userId,
      'status': 'pending',
      'routeId': routeId,
      'routeName': routeName,
      'pickupStopId': pickupStopId,
      'pickupStopName': pickupStopName,
      'destinationStopId': destinationStopId,
      'destinationStopName': destinationStopName,
      if (busId != null) 'busId': busId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}