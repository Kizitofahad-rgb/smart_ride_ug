import 'package:flutter/material.dart';

class NearbyStopCard extends StatelessWidget {
  final String stopName;
  final String distance;

  const NearbyStopCard({
    super.key,
    required this.stopName,
    required this.distance,
  });

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
        title: Text(stopName),
        subtitle: Text(distance),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO:
          // Navigate to Bus Stop Details
        },
      ),
    );
  }
}