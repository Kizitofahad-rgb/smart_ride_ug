import 'package:go_router/go_router.dart';

// Home Screen
import '../features/home/home_screen.dart';

// Passenger Flow (Mable)
import '../features/passenger/passenger_home_screen.dart';
import '../features/passenger/passenger_login_screen.dart';
import '../features/passenger/passenger_register_screen.dart';
import '../features/passenger/booking_screen.dart';
import '../features/passenger/trip_history_screen.dart';
import '../features/passenger/profile_screen.dart';
import '../features/passenger/notifications_screen.dart';

// Map Flow (Faisal)
import '../features/map/presentation/live_map_screen.dart'; // 🔥 FIX: Updated path
// 🔥 FIX: Removed driver_broadcast_screen import (it doesn't exist)

// Operator Flow (Mutebi)
import '../features/operator/operator_login_screen.dart';
import '../features/operator/operator_register_screen.dart';
import '../features/operator/operator_dashboard_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Home
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

    // Passenger Flow (Mable)
    GoRoute(
      path: '/passenger-login',
      name: 'passenger-login',
      builder: (context, state) => const PassengerLoginScreen(),
    ),
    GoRoute(
      path: '/passenger-register',
      name: 'passenger-register',
      builder: (context, state) => const PassengerRegisterScreen(),
    ),
    GoRoute(
      path: '/passenger-home',
      name: 'passenger-home',
      builder: (context, state) => const PassengerHomeScreen(),
    ),
    GoRoute(
      path: '/booking',
      name: 'booking',
      builder: (context, state) => const BookingScreen(),
    ),
    GoRoute(
      path: '/history',
      name: 'history',
      builder: (context, state) => const TripHistoryScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/notifications',
      name: 'notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),

    // Map Flow (Faisal)
    GoRoute(
      path: '/live-map',
      name: 'live-map',
      builder: (context, state) => const LiveMapScreen(),
    ),
    // 🔥 FIX: Removed '/driver' route

    // Operator Flow (Mutebi)
    GoRoute(
      path: '/operator-login',
      name: 'operator-login',
      builder: (context, state) => const OperatorLoginScreen(),
    ),
    GoRoute(
      path: '/operator-register',
      name: 'operator-register',
      builder: (context, state) => const OperatorRegisterScreen(),
    ),
    GoRoute(
      path: '/operator-dashboard',
      name: 'operator-dashboard',
      builder: (context, state) => const OperatorDashboardScreen(),
    ),
  ],
);
