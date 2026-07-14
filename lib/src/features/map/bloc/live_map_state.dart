import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import '../data/bus_location.dart';

class LiveMapState extends Equatable {
  /// True until the very first Firestore snapshot comes back.
  final bool isLoading;

  /// Null means "no bus document yet" — e.g. the driver hasn't started a
  /// trip. The UI should show a waiting state, not an error.
  final BusLocation? busLocation;

  final LatLng? destination;
  final String? destinationName;

  /// Straight-line distance from the bus to [destination], in meters.
  /// Null whenever either the bus or the destination is unknown.
  final double? distanceMeters;

  /// Estimated time to arrival at [destination], derived from
  /// [distanceMeters] and the bus's last reported speed.
  final Duration? eta;

  final bool hasArrived;

  const LiveMapState({
    this.isLoading = true,
    this.busLocation,
    this.destination,
    this.destinationName,
    this.distanceMeters,
    this.eta,
    this.hasArrived = false,
  });

  @override
  List<Object?> get props => [
        isLoading,
        busLocation,
        destination,
        destinationName,
        distanceMeters,
        eta,
        hasArrived,
      ];
}
