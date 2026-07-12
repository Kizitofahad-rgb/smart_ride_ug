import 'package:equatable/equatable.dart';

abstract class RoutesEvent extends Equatable {
  const RoutesEvent();

  @override
  List<Object?> get props => [];
}

/// Requests the route list be (re)loaded.
class LoadRoutes extends RoutesEvent {
  const LoadRoutes();
}