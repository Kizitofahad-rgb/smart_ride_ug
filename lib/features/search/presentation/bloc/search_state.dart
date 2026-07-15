import 'package:equatable/equatable.dart';

import '../../../routes/domain/models/bus_route.dart';
import '../../domain/models/destination.dart';

enum SearchStatus { initial, loading, loaded, error }

/// A single state class covering both stages of the search flow
/// (typing/filtering, and viewing route suggestions), rather than a
/// family of state subclasses. The two stages share almost all of
/// their data, and `selectedDestinationName` already tells the UI
/// which stage it's in — a state hierarchy here would be
/// over-engineering for what's still a simple screen (ADR: "never
/// over-engineer, prefer simplicity").
class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.allDestinations = const [],
    this.filteredDestinations = const [],
    this.selectedDestinationName,
    this.matchingRoutes = const [],
    this.errorMessage,
  });

  final SearchStatus status;
  final String query;
  final List<Destination> allDestinations;
  final List<Destination> filteredDestinations;
  final String? selectedDestinationName;
  final List<BusRoute> matchingRoutes;
  final String? errorMessage;

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<Destination>? allDestinations,
    List<Destination>? filteredDestinations,
    String? selectedDestinationName,
    bool clearSelection = false,
    List<BusRoute>? matchingRoutes,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      allDestinations: allDestinations ?? this.allDestinations,
      filteredDestinations: filteredDestinations ?? this.filteredDestinations,
      selectedDestinationName: clearSelection
          ? null
          : (selectedDestinationName ?? this.selectedDestinationName),
      matchingRoutes: matchingRoutes ?? this.matchingRoutes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    query,
    allDestinations,
    filteredDestinations,
    selectedDestinationName,
    matchingRoutes,
    errorMessage,
  ];
}