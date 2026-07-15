import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../bus_stops/data/repositories/dummy_bus_stops_repository.dart';
import '../../../bus_stops/presentation/bloc/bus_stops_bloc.dart';
import '../../../bus_stops/presentation/bloc/bus_stops_event.dart';
import '../../../bus_stops/presentation/bloc/bus_stops_state.dart';
import '../../../bus_stops/presentation/pages/bus_stop_details_page.dart';

/// Interactive Home map (ADR-005 — OpenStreetMap via `flutter_map`).
///
/// Replaces `MapPlaceholder`. Loads bus stops through the same
/// `BusStopsBloc`/`BusStopsRepository` the Bus Stops tab already
/// uses, rather than a separate copy of the dummy data (ADR-011 —
/// don't duplicate). When Firestore replaces `DummyBusStopsRepository`
/// later, this map's markers update automatically along with the
/// rest of the app — nothing here needs to change.
///
/// Tapping a marker opens `BusStopDetailsPage`, reusing the same
/// screen the Bus Stops list already navigates to.
class HomeMap extends StatelessWidget {
  const HomeMap({super.key});

  // Roughly Wandegeya / Makerere — the app's home base area.
  static const LatLng _initialCenter = LatLng(0.3327, 32.5705);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: SizedBox(
        height: 280,
        width: double.infinity,
        child: BlocProvider(
          create: (_) => BusStopsBloc(repository: DummyBusStopsRepository())
            ..add(const LoadBusStops()),
          child: BlocBuilder<BusStopsBloc, BusStopsState>(
            builder: (context, state) {
              return FlutterMap(
                options: const MapOptions(
                  initialCenter: _initialCenter,
                  initialZoom: 13,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.smartrideug.app',
                  ),
                  MarkerLayer(
                    markers: [
                      for (final stop in state.busStops)
                        Marker(
                          point: LatLng(stop.latitude, stop.longitude),
                          width: 36,
                          height: 36,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      BusStopDetailsPage(busStop: stop),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.location_on,
                              color: AppColors.primary,
                              size: 36,
                            ),
                          ),
                        ),
                    ],
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}