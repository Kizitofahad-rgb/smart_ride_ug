import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import '../data/bus_location.dart';

abstract class LiveMapEvent extends Equatable {
  const LiveMapEvent();

  @override
  List<Object?> get props => [];
}

/// Starts (or restarts) watching a bus's Firestore document. Pass
/// [initialDestinationName]/[initialDestinationPosition] together when the
/// passenger already picked a destination before opening the map (e.g. right
/// after reserving a seat at their nearest stop) so distance/ETA/arrival
/// are live from the first frame instead of waiting for a station tap.
class LiveMapStarted extends LiveMapEvent {
  final String busId;
  final String? initialDestinationName;
  final LatLng? initialDestinationPosition;
  const LiveMapStarted(
      this.busId, {
        this.initialDestinationName,
        this.initialDestinationPosition,
      });

  @override
  List<Object?> get props =>
      [busId, initialDestinationName, initialDestinationPosition];
}

/// Internal event fed by the Firestore stream subscription every time the
/// bus document changes.
class LiveMapBusLocationChanged extends LiveMapEvent {
  final BusLocation? location;
  const LiveMapBusLocationChanged(this.location);

  @override
  List<Object?> get props => [location];
}

/// Passenger tapped a station marker to pick it as their destination.
class LiveMapDestinationSelected extends LiveMapEvent {
  final String name;
  final LatLng position;
  const LiveMapDestinationSelected(this.name, this.position);

  @override
  List<Object?> get props => [name, position];
}

/// Passenger cleared their chosen destination.
class LiveMapDestinationCleared extends LiveMapEvent {
  const LiveMapDestinationCleared();
}

/// Internal event fed by the device GPS stream every time the passenger's
/// own position changes. Powers the live "you are here" dot, independent
/// of the bus's position.
class LiveMapUserLocationChanged extends LiveMapEvent {
  final LatLng position;
  const LiveMapUserLocationChanged(this.position);

  @override
  List<Object?> get props => [position];
}