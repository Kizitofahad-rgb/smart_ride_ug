import '../models/passenger_profile.dart';

/// Contract for fetching the signed-in passenger's profile.
abstract class ProfileRepository {
  Future<PassengerProfile> fetchProfile();
}