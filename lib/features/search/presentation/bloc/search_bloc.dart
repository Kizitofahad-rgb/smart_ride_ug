import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../routes/domain/repositories/routes_repository.dart';
import '../../domain/repositories/destinations_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

/// Manages Destination Search state: the current query, filtered
/// destination results, and — once a destination is picked — the
/// routes that serve it.
///
/// Depends on two repositories: its own `DestinationsRepository`,
/// and `RoutesRepository` from the Routes feature. Reusing Routes'
/// repository here (instead of a second copy of route-fetching
/// logic) is the same deliberate cross-feature reuse as `RouteCard`
/// — one source of truth for "how do we get routes", not two.
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required DestinationsRepository destinationsRepository,
    required RoutesRepository routesRepository,
  })  : _destinationsRepository = destinationsRepository,
        _routesRepository = routesRepository,
        super(const SearchState()) {
    on<LoadDestinations>(_onLoadDestinations);
    on<SearchQueryChanged>(_onQueryChanged);
    on<DestinationSelected>(_onDestinationSelected);
    on<SearchCleared>(_onSearchCleared);
  }

  final DestinationsRepository _destinationsRepository;
  final RoutesRepository _routesRepository;

  Future<void> _onLoadDestinations(
      LoadDestinations event,
      Emitter<SearchState> emit,
      ) async {
    emit(state.copyWith(status: SearchStatus.loading));

    try {
      final destinations = await _destinationsRepository.fetchDestinations();

      emit(state.copyWith(
        status: SearchStatus.loaded,
        allDestinations: destinations,
        filteredDestinations: destinations,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: SearchStatus.error,
        errorMessage: 'Could not load destinations.',
      ));
    }
  }

  void _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) {
    final lowerQuery = event.query.toLowerCase();

    final filtered = lowerQuery.isEmpty
        ? state.allDestinations
        : state.allDestinations
        .where((d) => d.name.toLowerCase().contains(lowerQuery))
        .toList();

    emit(state.copyWith(
      query: event.query,
      filteredDestinations: filtered,
    ));
  }

  Future<void> _onDestinationSelected(
      DestinationSelected event,
      Emitter<SearchState> emit,
      ) async {
    final allRoutes = await _routesRepository.fetchRoutes();

    final matching = allRoutes
        .where((route) => route.stops.contains(event.destinationName))
        .toList();

    emit(state.copyWith(
      selectedDestinationName: event.destinationName,
      matchingRoutes: matching,
    ));
  }

  void _onSearchCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(state.copyWith(
      query: '',
      filteredDestinations: state.allDestinations,
      clearSelection: true,
      matchingRoutes: const [],
    ));
  }
}