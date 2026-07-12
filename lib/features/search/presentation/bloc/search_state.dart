import 'package:equatable/equatable.dart';

import '../../../routes/domain/models/bus_route.dart';
import '../../domain/models/destination.dart';

/// A single state class covering both stages of the search flow
/// (typing/filtering, and viewing route suggestions), rather than a
/// family of state subclasses. The two stages share almost all of
/// their data, and `selectedDestinationName` already tells the UI
/// which stage it's in — a state hierarchy here would be
/// over-engineering for what's still a simple screen (ADR: "never
/// over-engineer, prefer simplicity").
class SearchState extends Equatable {
  const SearchState({
    this.query = '',
    this.filteredDestinations = const [],
    this.selectedDestinationName,
    this.matchingRoutes = const [],
  });

  final String query;
  final List<Destination> filteredDestinations;
  final String? selectedDestinationName;
  final List<BusRoute> matchingRoutes;

  SearchState copyWith({
    String? query,
    List<Destination>? filteredDestinations,
    String? selectedDestinationName,
    bool clearSelection = false,
    List<BusRoute>? matchingRoutes,
  }) {
    return SearchState(
      query: query ?? this.query,
      filteredDestinations: filteredDestinations ?? this.filteredDestinations,
      selectedDestinationName: clearSelection
          ? null
          : (selectedDestinationName ?? this.selectedDestinationName),
      matchingRoutes: matchingRoutes ?? this.matchingRoutes,
    );
  }

  @override
  List<Object?> get props => [
    query,
    filteredDestinations,
    selectedDestinationName,
    matchingRoutes,
  ];
}