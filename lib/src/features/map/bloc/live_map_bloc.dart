import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/services/location_service.dart';
import '../data/bus_location.dart';
import '../data/bus_tracking_repository.dart';
import 'live_map_event.dart';
import 'live_map_state.dart';

/// Distance (in meters) within which we consider the bus to have "arrived"
/// at the passenger's chosen destination.
const double kArrivalRadiusMeters = 80;

class LiveMapBloc extends Bloc<LiveMapEvent, LiveMapState> {
  LiveMapBloc({BusTrackingRepository? repository, LocationService? locationService})
      : _repository = repository ?? BusTrackingRepository(),
        _locationService = locationService ?? LocationService.instance,
        super(const LiveMapState()) {
    on<LiveMapStarted>(_onStarted);
    on<LiveMapBusLocationChanged>(_onBusLocationChanged);
    on<LiveMapDestinationSelected>(_onDestinationSelected);
    on<LiveMapDestinationCleared>(_onDestinationCleared);
    on<LiveMapUserLocationChanged>(_onUserLocationChanged);
  }

  final BusTrackingRepository _repository;
  final LocationService _locationService;
  StreamSubscription<BusLocation?>? _busSubscription;
  StreamSubscription<Position>? _userSubscription;

  Future<void> _onStarted(
      LiveMapStarted event,
      Emitter<LiveMapState> emit,
      ) async {
    emit(_buildState(
      isLoading: true,
      busLocation: state.busLocation,
      destination: event.initialDestinationPosition ?? state.destination,
      destinationName: event.initialDestinationName ?? state.destinationName,
      userPosition: state.userPosition,
    ));

    await _busSubscription?.cancel();
    _busSubscription = _repository.watchBus(event.busId).listen(
          (location) => add(LiveMapBusLocationChanged(location)),
    );

    // Best-effort: if the passenger has denied location permission, the
    // map still works fine, it just won't show their own live dot.
    await _userSubscription?.cancel();
    final granted = await _locationService.ensurePermission();
    if (granted) {
      _userSubscription = _locationService.watchPosition().listen(
            (position) => add(
          LiveMapUserLocationChanged(LatLng(position.latitude, position.longitude)),
        ),
      );
    }
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
      userPosition: state.userPosition,
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
      userPosition: state.userPosition,
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
      userPosition: state.userPosition,
    ));
  }

  void _onUserLocationChanged(
      LiveMapUserLocationChanged event,
      Emitter<LiveMapState> emit,
      ) {
    emit(_buildState(
      isLoading: state.isLoading,
      busLocation: state.busLocation,
      destination: state.destination,
      destinationName: state.destinationName,
      userPosition: event.position,
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
    required LatLng? userPosition,
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
      userPosition: userPosition,
      distanceMeters: distance,
      eta: eta,
      hasArrived: arrived,
    );
  }

  @override
  Future<void> close() {
    _busSubscription?.cancel();
    _userSubscription?.cancel();
    return super.close();
  }
}