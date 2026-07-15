import 'package:equatable/equatable.dart';

import '../../domain/models/bus_stop.dart';

enum BusStopsStatus { initial, loading, loaded, error }

class BusStopsState extends Equatable {
  const BusStopsState({
    this.status = BusStopsStatus.initial,
    this.busStops = const [],
    this.errorMessage,
  });

  final BusStopsStatus status;
  final List<BusStop> busStops;
  final String? errorMessage;

  BusStopsState copyWith({
    BusStopsStatus? status,
    List<BusStop>? busStops,
    String? errorMessage,
  }) {
    return BusStopsState(
      status: status ?? this.status,
      busStops: busStops ?? this.busStops,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, busStops, errorMessage];
}