import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class SmartRideApp extends StatelessWidget {
  const SmartRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Ride UG',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      initialRoute: AppRouter.splash,

      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}