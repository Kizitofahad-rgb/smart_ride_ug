import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_placeholder.dart';

/// Placeholder for the Profile tab.
///
/// Will be replaced once Firebase Authentication is integrated and
/// real user data is available (see ADR-006).
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const ComingSoonPlaceholder(
        icon: Icons.person_outline,
        message: 'Your profile will appear here.',
      ),
    );
  }
}