import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../bloc/bus_stops_bloc.dart';
import '../bloc/bus_stops_event.dart';
import '../bloc/bus_stops_state.dart';
import '../widgets/bus_stop_card.dart';
import 'bus_stop_details_page.dart';

/// Bus stop list screen.
///
/// Now backed by `BusStopsBloc` instead of reading `dummyBusStops`
/// directly, matching the pattern established in `RoutesPage`.
class BusStopsPage extends StatelessWidget {
  const BusStopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BusStopsBloc()..add(const LoadBusStops()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bus Stops'),
        ),
        body: BlocBuilder<BusStopsBloc, BusStopsState>(
          builder: (context, state) {
            switch (state.status) {
              case BusStopsStatus.initial:
              case BusStopsStatus.loading:
                return const Center(child: CircularProgressIndicator());

              case BusStopsStatus.error:
                return Center(
                  child: Text(state.errorMessage ?? 'Something went wrong.'),
                );

              case BusStopsStatus.loaded:
                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: state.busStops.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final busStop = state.busStops[index];

                    return BusStopCard(
                      busStop: busStop,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BusStopDetailsPage(busStop: busStop),
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