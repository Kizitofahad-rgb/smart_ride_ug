import 'package:flutter/material.dart';

import '../../domain/models/bus_stop.dart';

/// A single row in the bus stop list.
///
/// This deliberately looks like Home's `NearbyStopCard`, but it is
/// NOT the same widget reused across features — `NearbyStopCard` is
/// a Home-dashboard widget bound to Home's layout, while this one
/// belongs to the Bus Stops feature and carries a full `BusStop`
/// (routes served, coordinates) rather than just a name/distance
/// pair. Keeping them separate avoids coupling two features through
/// a shared widget that would need to grow two different shapes
/// over time.
class BusStopCard extends StatelessWidget {
  const BusStopCard({
    super.key,
    required this.busStop,
    required this.onTap,
  });

  final BusStop busStop;
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
          child: Icon(Icons.location_on),
        ),
        title: Text(busStop.name),
        subtitle: Text(
          '${busStop.distance} • ${busStop.routesServed.length} route(s)',
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}