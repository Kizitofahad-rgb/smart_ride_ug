import 'package:flutter/material.dart';

import '../../domain/models/destination.dart';

/// A single search result row.
class DestinationTile extends StatelessWidget {
  const DestinationTile({
    super.key,
    required this.destination,
    required this.onTap,
  });

  final Destination destination;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.place_outlined),
      title: Text(destination.name),
      subtitle: Text(destination.area),
      onTap: onTap,
    );
  }
}