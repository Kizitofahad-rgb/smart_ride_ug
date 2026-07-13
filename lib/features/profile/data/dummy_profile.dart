import '../domain/models/passenger_profile.dart';

/// Temporary static profile, standing in for Firebase Auth /
/// Firestore user data (ADR-006/ADR-007).
const PassengerProfile dummyProfile = PassengerProfile(
  fullName: 'Faisal',
  email: 'faisal@example.com',
  phoneNumber: '+256 700 000000',
  memberSince: 'July 2026',
);