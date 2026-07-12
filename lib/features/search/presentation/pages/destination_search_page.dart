import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../routes/presentation/pages/route_details_page.dart';
import '../../../routes/presentation/widgets/route_card.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../widgets/destination_tile.dart';

/// Destination Search screen.
///
/// Flow: passenger types a destination -> picks one from the
/// filtered list -> sees which routes actually serve it. All of that
/// state now lives in `SearchBloc`; this widget only renders it and
/// dispatches events. The `TextEditingController` is the one piece
/// that must stay local (BLoC doesn't own widget controllers), so
/// this outer widget just provides the BLoC and hands off to a
/// small StatefulWidget beneath it.
class DestinationSearchPage extends StatelessWidget {
  const DestinationSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(),
      child: const _DestinationSearchView(),
    );
  }
}

class _DestinationSearchView extends StatefulWidget {
  const _DestinationSearchView();

  @override
  State<_DestinationSearchView> createState() =>
      _DestinationSearchViewState();
}

class _DestinationSearchViewState extends State<_DestinationSearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Where to?'),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          final selected = state.selectedDestinationName;

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _controller,
                  autofocus: selected == null,
                  decoration: InputDecoration(
                    hintText: 'Search for a destination',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: selected != null
                        ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _controller.clear();
                        context
                            .read<SearchBloc>()
                            .add(const SearchCleared());
                      },
                    )
                        : null,
                  ),
                  onChanged: (value) {
                    context.read<SearchBloc>().add(SearchQueryChanged(value));
                  },
                ),

                const SizedBox(height: AppSpacing.lg),

                Expanded(
                  child: selected == null
                      ? _buildDestinationList(context, state)
                      : _buildRouteSuggestions(context, state, selected),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDestinationList(BuildContext context, SearchState state) {
    if (state.filteredDestinations.isEmpty) {
      return const Center(
        child: Text('No destinations match your search.'),
      );
    }

    return ListView.builder(
      itemCount: state.filteredDestinations.length,
      itemBuilder: (context, index) {
        final destination = state.filteredDestinations[index];

        return DestinationTile(
          destination: destination,
          onTap: () {
            context
                .read<SearchBloc>()
                .add(DestinationSelected(destination.name));
          },
        );
      },
    );
  }

  Widget _buildRouteSuggestions(
      BuildContext context,
      SearchState state,
      String destinationName,
      ) {
    final routes = state.matchingRoutes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Routes serving $destinationName',
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const SizedBox(height: AppSpacing.sm),

        Expanded(
          child: routes.isEmpty
              ? const Center(
            child: Text('No routes currently serve this destination.'),
          )
              : ListView.separated(
            itemCount: routes.length,
            separatorBuilder: (_, __) =>
            const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final route = routes[index];

              return RouteCard(
                route: route,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RouteDetailsPage(route: route),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}