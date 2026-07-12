import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/routes_repository.dart';
import 'routes_event.dart';
import 'routes_state.dart';

/// Manages the state of the route list.
///
/// Depends on `RoutesRepository` (an interface), not on any
/// concrete data source. Right now `DummyRoutesRepository` is
/// injected wherever this BLoC is created; swapping in a
/// Firestore-backed repository later means changing that one
/// injection site, not this class.
class RoutesBloc extends Bloc<RoutesEvent, RoutesState> {
  RoutesBloc({required RoutesRepository repository})
      : _repository = repository,
        super(const RoutesState()) {
    on<LoadRoutes>(_onLoadRoutes);
  }

  final RoutesRepository _repository;

  Future<void> _onLoadRoutes(
      LoadRoutes event,
      Emitter<RoutesState> emit,
      ) async {
    emit(state.copyWith(status: RoutesStatus.loading));

    try {
      final routes = await _repository.fetchRoutes();

      emit(state.copyWith(
        status: RoutesStatus.loaded,
        routes: routes,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: RoutesStatus.error,
        errorMessage: 'Could not load routes.',
      ));
    }
  }
}