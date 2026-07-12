import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../routes/data/dummy_routes.dart';
import '../../data/dummy_destinations.dart';
import 'search_event.dart';
import 'search_state.dart';

/// Manages Destination Search state: the current query, filtered
/// destination results, and — once a destination is picked — the
/// routes that serve it.
///
/// Like `RoutesBloc` and `BusStopsBloc`, this reads
/// `dummyDestinations`/`dummyRoutes` directly for now; the
/// Repository Layer step comes later (ADR-007).
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc()
      : super(SearchState(filteredDestinations: dummyDestinations)) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<DestinationSelected>(_onDestinationSelected);
    on<SearchCleared>(_onSearchCleared);
  }

  void _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) {
    final lowerQuery = event.query.toLowerCase();

    final filtered = lowerQuery.isEmpty
        ? dummyDestinations
        : dummyDestinations
        .where((d) => d.name.toLowerCase().contains(lowerQuery))
        .toList();

    emit(state.copyWith(
      query: event.query,
      filteredDestinations: filtered,
    ));
  }

  void _onDestinationSelected(
      DestinationSelected event,
      Emitter<SearchState> emit,
      ) {
    final matching = dummyRoutes
        .where((route) => route.stops.contains(event.destinationName))
        .toList();

    emit(state.copyWith(
      selectedDestinationName: event.destinationName,
      matchingRoutes: matching,
    ));
  }

  void _onSearchCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(SearchState(filteredDestinations: dummyDestinations));
  }
}