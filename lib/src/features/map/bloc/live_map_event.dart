import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import '../data/bus_location.dart';

abstract class LiveMapEvent extends Equatable {
  const LiveMapEvent();

  @override
  List<Object?> get props => [];
}

/// Starts (or restarts) watching a bus's Firestore document.
class LiveMapStarted extends LiveMapEvent {
  final String busId;
  const LiveMapStarted(this.busId);

  @override
  List<Object?> get props => [busId];
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
