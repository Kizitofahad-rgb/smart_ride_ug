import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Requests the profile be (re)loaded.
class LoadProfile extends ProfileEvent {
  const LoadProfile();
}