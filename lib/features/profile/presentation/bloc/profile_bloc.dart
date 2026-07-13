import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// Manages the state of the signed-in passenger's profile. Same
/// shape as `RoutesBloc`/`BusStopsBloc`/`SearchBloc` — depends on a
/// repository interface, not a concrete data source.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required ProfileRepository repository})
      : _repository = repository,
        super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
  }

  final ProfileRepository _repository;

  Future<void> _onLoadProfile(
      LoadProfile event,
      Emitter<ProfileState> emit,
      ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final profile = await _repository.fetchProfile();

      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Could not load profile.',
      ));
    }
  }
}