import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_placeholder.dart';

/// Placeholder for the Notifications tab.
///
/// Will be replaced once Firebase Cloud Messaging is integrated
/// (see ADR-003 and ADR-007 — Firebase comes after UI/navigation).
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: const ComingSoonPlaceholder(
        icon: Icons.notifications_outlined,
        message: 'Notifications will appear here.',
      ),
    );
  }
}