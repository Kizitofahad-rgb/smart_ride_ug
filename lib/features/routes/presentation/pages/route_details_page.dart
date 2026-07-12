import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/models/bus_route.dart';

/// Full details for a single route, reached by tapping a RouteCard.
///
/// This is pushed directly with `Navigator.push` rather than added
/// to the central named-route switch in `AppRouter`, because it
/// needs a `BusRoute` argument. Keeping simple, parameterised pushes
/// like this outside the named-route table avoids over-engineering
/// the router for something this small.
class RouteDetailsPage extends StatelessWidget {
  const RouteDetailsPage({
    super.key,
    required this.route,
  });

  final BusRoute route;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(route.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Row(
            children: [
              _InfoChip(
                icon: Icons.timer_outlined,
                label: route.estimatedDuration,
              ),
              const SizedBox(width: AppSpacing.sm),
              _InfoChip(
                icon: Icons.social_distance_outlined,
                label: '${route.distanceKm} km',
              ),
              const SizedBox(width: AppSpacing.sm),
              _InfoChip(
                icon: Icons.directions_bus_outlined,
                label: '${route.activeBuses} active',
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          Text(
            'Stops',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: AppSpacing.sm),

          for (int i = 0; i < route.stops.length; i++)
            _StopTile(
              stopName: route.stops[i],
              isFirst: i == 0,
              isLast: i == route.stops.length - 1,
            ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StopTile extends StatelessWidget {
  const _StopTile({
    required this.stopName,
    required this.isFirst,
    required this.isLast,
  });

  final String stopName;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFirst || isLast
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Text(
            stopName,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}