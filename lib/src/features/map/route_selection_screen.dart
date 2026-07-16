import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'data/bus_route.dart';
import 'data/routes_repository.dart';
import 'data/stop.dart';

/// Step 2 of "Find My Bus": shows every route that serves the destination
/// stop the passenger just picked. Tapping one opens [RouteDetailScreen].
class RouteSelectionScreen extends StatelessWidget {
  const RouteSelectionScreen({super.key, required this.destination});

  final Stop destination;

  @override
  Widget build(BuildContext context) {
    final repository = RoutesRepository();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        title: Text('Routes to ${destination.name}'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<BusRoute>>(
        stream: repository.watchRoutesServingStop(destination.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2563EB)),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Could not load routes: ${snapshot.error}',
                style: const TextStyle(color: Color(0xFFF59E0B)),
              ),
            );
          }

          final routes = snapshot.data ?? const <BusRoute>[];
          if (routes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No routes currently serve ${destination.name}.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF94A3B8)),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: routes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final route = routes[index];
              return _RouteCard(
                route: route,
                onTap: () => context.push(
                  '/route-detail',
                  extra: (route, destination),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.route, required this.onTap});

  final BusRoute route;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(route.colorValue).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.directions_bus,
                    color: Color(route.colorValue)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${route.stopIds.length} stops  •  ${route.formattedFare}  •  ${route.formattedHeadway}',
                      style: const TextStyle(color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF64748B)),
            ],
          ),
        ),
      ),
    );
  }
}