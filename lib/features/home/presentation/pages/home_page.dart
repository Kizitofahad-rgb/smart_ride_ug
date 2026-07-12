import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../widgets/destination_search.dart';
import '../widgets/home_header.dart';
import '../widgets/map_placeholder.dart';
import '../widgets/nearby_stop_card.dart';
import '../widgets/quick_action_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),

              const SizedBox(height: AppSpacing.lg),

              const DestinationSearch(),

              const SizedBox(height: AppSpacing.lg),

              const MapPlaceholder(),

              const SizedBox(height: AppSpacing.xl),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Nearby Bus Stops",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("See All"),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.sm),

              const NearbyStopCard(
                stopName: "Wandegeya",
                distance: "250 m away",
              ),

              const NearbyStopCard(
                stopName: "Mulago",
                distance: "600 m away",
              ),

              const NearbyStopCard(
                stopName: "Kamwokya",
                distance: "1.1 km away",
              ),

              const SizedBox(height: AppSpacing.xl),

              Text(
                "Quick Actions",
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  QuickActionCard(
                    icon: Icons.alt_route,
                    title: "Routes",
                    onTap: () {},
                  ),
                  const SizedBox(width: AppSpacing.md),
                  QuickActionCard(
                    icon: Icons.location_on,
                    title: "Bus Stops",
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  QuickActionCard(
                    icon: Icons.bookmark_outline,
                    title: "Reservations",
                    onTap: () {},
                  ),
                  const SizedBox(width: AppSpacing.md),
                  QuickActionCard(
                    icon: Icons.directions_bus,
                    title: "Track Bus",
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}