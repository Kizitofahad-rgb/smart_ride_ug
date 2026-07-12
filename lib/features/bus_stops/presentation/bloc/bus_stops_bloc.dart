import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/dummy_bus_stops.dart';
import 'bus_stops_event.dart';
import 'bus_stops_state.dart';

/// Manages the state of the bus stop list.
///
/// Same pattern as `RoutesBloc` — reads `dummyBusStops` directly for
/// now, will be pointed at a repository once Firebase (Step 6) is
/// introduced (ADR-007).
class BusStopsBloc extends Bloc<BusStopsEvent, BusStopsState> {
  BusStopsBloc() : super(const BusStopsState()) {
    on<LoadBusStops>(_onLoadBusStops);
  }

  Future<void> _onLoadBusStops(
      LoadBusStops event,
      Emitter<BusStopsState> emit,
      ) async {
    emit(state.copyWith(status: BusStopsStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      emit(state.copyWith(
        status: BusStopsStatus.loaded,
        busStops: dummyBusStops,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: BusStopsStatus.error,
        errorMessage: 'Could not load bus stops.',
      ));
    }
  }
}