import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../data/bus_location.dart';
import '../data/bus_tracking_repository.dart';
import 'live_map_event.dart';
import 'live_map_state.dart';

/// Distance (in meters) within which we consider the bus to have "arrived"
/// at the passenger's chosen destination.
const double kArrivalRadiusMeters = 80;

class LiveMapBloc extends Bloc<LiveMapEvent, LiveMapState> {
  LiveMapBloc({BusTrackingRepository? repository})
      : _repository = repository ?? BusTrackingRepository(),
        super(const LiveMapState()) {
    on<LiveMapStarted>(_onStarted);
    on<LiveMapBusLocationChanged>(_onBusLocationChanged);
    on<LiveMapDestinationSelected>(_onDestinationSelected);
    on<LiveMapDestinationCleared>(_onDestinationCleared);
  }

  final BusTrackingRepository _repository;
  StreamSubscription<BusLocation?>? _busSubscription;

  Future<void> _onStarted(
    LiveMapStarted event,
    Emitter<LiveMapState> emit,
  ) async {
    emit(_buildState(
      isLoading: true,
      busLocation: state.busLocation,
      destination: state.destination,
      destinationName: state.destinationName,
    ));

    await _busSubscription?.cancel();
    _busSubscription = _repository.watchBus(event.busId).listen(
          (location) => add(LiveMapBusLocationChanged(location)),
        );
  }

  void _onBusLocationChanged(
    LiveMapBusLocationChanged event,
    Emitter<LiveMapState> emit,
  ) {
    emit(_buildState(
      isLoading: false,
      busLocation: event.location,
      destination: state.destination,
      destinationName: state.destinationName,
    ));
  }

  void _onDestinationSelected(
    LiveMapDestinationSelected event,
    Emitter<LiveMapState> emit,
  ) {
    emit(_buildState(
      isLoading: state.isLoading,
      busLocation: state.busLocation,
      destination: event.position,
      destinationName: event.name,
    ));
  }

  void _onDestinationCleared(
    LiveMapDestinationCleared event,
    Emitter<LiveMapState> emit,
  ) {
    emit(_buildState(
      isLoading: state.isLoading,
      busLocation: state.busLocation,
      destination: null,
      destinationName: null,
    ));
  }

  /// Single place that (re)computes distance / ETA / arrival, so the two
  /// things that can trigger a recalculation — the bus moving, or the
  /// passenger picking a new destination — can't drift out of sync.
  LiveMapState _buildState({
    required bool isLoading,
    required BusLocation? busLocation,
    required LatLng? destination,
    required String? destinationName,
  }) {
    double? distance;
    Duration? eta;
    var arrived = false;

    if (busLocation != null && destination != null) {
      distance = GeoUtils.distanceMeters(busLocation.position, destination);
      eta = GeoUtils.estimateArrival(
        distanceMeters: distance,
        speedKmh: busLocation.speedKmh,
      );
      arrived = distance <= kArrivalRadiusMeters;
    }

    return LiveMapState(
      isLoading: isLoading,
      busLocation: busLocation,
      destination: destination,
      destinationName: destinationName,
      distanceMeters: distance,
      eta: eta,
      hasArrived: arrived,
    );
  }

  @override
  Future<void> close() {
    _busSubscription?.cancel();
    return super.close();
  }
}
