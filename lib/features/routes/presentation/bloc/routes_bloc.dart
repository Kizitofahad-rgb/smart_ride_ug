import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/dummy_routes.dart';
import 'routes_event.dart';
import 'routes_state.dart';

/// Manages the state of the route list.
///
/// `_onLoadRoutes` reads directly from `dummyRoutes` for now. Per
/// ADR-007, the Repository Layer is introduced as its own later
/// step, so this BLoC intentionally does NOT go through a repository
/// yet. When Step 6 (Firebase) begins, only the body of
/// `_onLoadRoutes` needs to change to call something like
/// `RoutesRepository.fetchRoutes()` — the event/state contract, and
/// every widget depending on it, stays the same.
class RoutesBloc extends Bloc<RoutesEvent, RoutesState> {
  RoutesBloc() : super(const RoutesState()) {
    on<LoadRoutes>(_onLoadRoutes);
  }

  Future<void> _onLoadRoutes(
      LoadRoutes event,
      Emitter<RoutesState> emit,
      ) async {
    emit(state.copyWith(status: RoutesStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      emit(state.copyWith(
        status: RoutesStatus.loaded,
        routes: dummyRoutes,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: RoutesStatus.error,
        errorMessage: 'Could not load routes.',
      ));
    }
  }
}