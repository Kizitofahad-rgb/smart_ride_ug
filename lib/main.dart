import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/routing/app_router.dart';
//import 'src/services/firebase/notification_service.dart';
import 'src/services/cache/cache_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. Initialize Notifications
  //await NotificationService().init();

  // 3. Initialize Cache (Offline-first)
  await CacheService().init();

  // 4. Start the app
  runApp(const SmartRideApp());
}

class SmartRideApp extends StatelessWidget {
  const SmartRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Ride UG',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF2563EB),
        scaffoldBackgroundColor: const Color(0xFF0A0E1A),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
