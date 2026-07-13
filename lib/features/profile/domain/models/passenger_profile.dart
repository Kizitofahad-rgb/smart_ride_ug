/// Represents the signed-in passenger's profile information.
///
/// Plain model, no Firebase Auth mapping yet (ADR-006 — auth UI
/// first, Firebase integration later). When Firebase Auth is wired
/// up, `ProfileRepository`'s implementation changes to read from
/// `FirebaseAuth.instance.currentUser` / a Firestore `users`
/// document instead of a dummy object — this model itself likely
/// stays the same shape.
class PassengerProfile {
  const PassengerProfile({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.memberSince,
  });

  final String fullName;
  final String email;
  final String phoneNumber;
  final String memberSince;
}