import 'package:equatable/equatable.dart';

import '../../domain/models/bus_route.dart';

enum RoutesStatus { initial, loading, loaded, error }

class RoutesState extends Equatable {
  const RoutesState({
    this.status = RoutesStatus.initial,
    this.routes = const [],
    this.errorMessage,
  });

  final RoutesStatus status;
  final List<BusRoute> routes;
  final String? errorMessage;

  RoutesState copyWith({
    RoutesStatus? status,
    List<BusRoute>? routes,
    String? errorMessage,
  }) {
    return RoutesState(
      status: status ?? this.status,
      routes: routes ?? this.routes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, routes, errorMessage];
}