import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// Requests the full destination list be loaded, so it can be
/// filtered locally as the passenger types.
class LoadDestinations extends SearchEvent {
  const LoadDestinations();
}

/// Fired as the passenger types in the search field.
class SearchQueryChanged extends SearchEvent {
  const SearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Fired when the passenger taps a destination from the results.
class DestinationSelected extends SearchEvent {
  const DestinationSelected(this.destinationName);

  final String destinationName;

  @override
  List<Object?> get props => [destinationName];
}

/// Fired when the passenger clears their selection to search again.
class SearchCleared extends SearchEvent {
  const SearchCleared();
}