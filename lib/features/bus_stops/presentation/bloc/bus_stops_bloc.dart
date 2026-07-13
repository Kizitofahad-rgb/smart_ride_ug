import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/bus_stops_repository.dart';
import 'bus_stops_event.dart';
import 'bus_stops_state.dart';

/// Manages the state of the bus stop list.
///
/// Depends on `BusStopsRepository` (an interface), matching the
/// pattern in `RoutesBloc`.
class BusStopsBloc extends Bloc<BusStopsEvent, BusStopsState> {
  BusStopsBloc({required BusStopsRepository repository})
      : _repository = repository,
        super(const BusStopsState()) {
    on<LoadBusStops>(_onLoadBusStops);
  }

  final BusStopsRepository _repository;

  Future<void> _onLoadBusStops(
      LoadBusStops event,
      Emitter<BusStopsState> emit,
      ) async {
    emit(state.copyWith(status: BusStopsStatus.loading));

    try {
      final busStops = await _repository.fetchBusStops();

      emit(state.copyWith(
        status: BusStopsStatus.loaded,
        busStops: busStops,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: BusStopsStatus.error,
        errorMessage: 'Could not load bus stops.',
      ));
    }
  }
}