import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/models/bus_stop.dart';

/// Full details for a single bus stop, reached by tapping a
/// BusStopCard.
///
/// Pushed directly with `Navigator.push`, same reasoning as
/// `RouteDetailsPage` — it needs a `BusStop` argument, so it doesn't
/// belong in the central named-route switch in `AppRouter`.
class BusStopDetailsPage extends StatelessWidget {
  const BusStopDetailsPage({
    super.key,
    required this.busStop,
  });

  final BusStop busStop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(busStop.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Row(
            children: [
              const Icon(Icons.place_outlined, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                busStop.distance,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          Text(
            'Routes Served',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: AppSpacing.sm),

          for (final routeName in busStop.routesServed)
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.alt_route),
                title: Text(routeName),
              ),
            ),

          const SizedBox(height: AppSpacing.xl),

          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.map_outlined, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.sm),
                const Expanded(
                  child: Text(
                    'Map view will appear here once OpenStreetMap is integrated.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}