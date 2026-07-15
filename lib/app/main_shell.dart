import 'package:flutter/material.dart';

import '../core/widgets/app_bottom_nav_bar.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/notification/presentation/pages/notifications_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/routes/presentation/pages/routes_page.dart';

/// The root shell for the authenticated/guest passenger experience.
///
/// Owns the currently selected bottom-navigation tab and keeps each
/// tab's page alive via IndexedStack, so switching tabs preserves
/// scroll position and state instead of rebuilding from scratch.
///
/// Lives in app/ rather than inside a single feature because it
/// composes multiple features together — it isn't itself a feature,
/// it's app-level navigation glue (consistent with router.dart and
/// theme.dart living here too).
///
/// No BLoC is used here yet. Per ADR-007, state management is
/// introduced only after navigation is complete; a simple
/// StatefulWidget with a local index is the right level of
/// complexity for this step.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  static const List<Widget> _tabs = [
    HomePage(),
    RoutesPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs,
      ),

      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}