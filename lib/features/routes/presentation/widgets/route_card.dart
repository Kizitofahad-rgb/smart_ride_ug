import 'package:flutter/material.dart';

import '../../domain/models/bus_route.dart';

/// A single row in the route list.
///
/// Feature-specific (unlike AppBottomNavBar), so it lives under
/// `features/routes/presentation/widgets`, not `core/widgets`.
class RouteCard extends StatelessWidget {
  const RouteCard({
    super.key,
    required this.route,
    required this.onTap,
  });

  final BusRoute route;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.alt_route),
        ),
        title: Text(route.name),
        subtitle: Text(
          '${route.estimatedDuration} • ${route.activeBuses} buses active',
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}