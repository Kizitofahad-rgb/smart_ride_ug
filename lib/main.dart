import 'package:flutter/material.dart';
import 'src/theme/app_theme.dart';
import 'src/features/operator/operator_dashboard_screen.dart';

void main() {
  runApp(const SmartRideApp());
}

class SmartRideApp extends StatelessWidget {
  const SmartRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Ride UG',
      theme: AppTheme.light(),
      home: const OperatorDashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
