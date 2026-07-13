import '../../domain/models/passenger_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../dummy_profile.dart';

/// Temporary `ProfileRepository` backed by `dummyProfile`. Swap for
/// a `FirebaseAuthProfileRepository` once Firebase Auth is
/// integrated (ADR-006).
class DummyProfileRepository implements ProfileRepository {
  @override
  Future<PassengerProfile> fetchProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return dummyProfile;
  }
}