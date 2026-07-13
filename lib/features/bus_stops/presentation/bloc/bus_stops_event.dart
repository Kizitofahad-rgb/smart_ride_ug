import 'package:equatable/equatable.dart';

abstract class BusStopsEvent extends Equatable {
  const BusStopsEvent();

  @override
  List<Object?> get props => [];
}

/// Requests the bus stop list be (re)loaded.
class LoadBusStops extends BusStopsEvent {
  const LoadBusStops();
}