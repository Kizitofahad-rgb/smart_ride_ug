import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../data/repositories/dummy_routes_repository.dart';
import '../bloc/routes_bloc.dart';
import '../bloc/routes_event.dart';
import '../bloc/routes_state.dart';
import '../widgets/route_card.dart';
import 'route_details_page.dart';

/// Route list screen — the Routes tab.
///
/// Now backed by `RoutesBloc` instead of reading `dummyRoutes`
/// directly. The BLoC still ultimately reads the same dummy list
/// (see ADR-007 — Repository Layer comes later), but the page itself
/// no longer knows or cares where the data comes from.
class RoutesPage extends StatelessWidget {
  const RoutesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoutesBloc(repository: DummyRoutesRepository())
        ..add(const LoadRoutes()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Routes'),
        ),
        body: BlocBuilder<RoutesBloc, RoutesState>(
          builder: (context, state) {
            switch (state.status) {
              case RoutesStatus.initial:
              case RoutesStatus.loading:
                return const Center(child: CircularProgressIndicator());

              case RoutesStatus.error:
                return Center(
                  child: Text(state.errorMessage ?? 'Something went wrong.'),
                );

              case RoutesStatus.loaded:
                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: state.routes.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final route = state.routes[index];

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
                );
            }
          },
        ),
      ),
    );
  }
}