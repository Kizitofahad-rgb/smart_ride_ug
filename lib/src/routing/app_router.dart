import 'package:go_router/go_router.dart';

// Home Screen
import '../features/home/home_screen.dart';

// Passenger Flow (Mable)
import '../features/passenger/passenger_home_screen.dart';
import '../features/passenger/booking_screen.dart';
import '../features/passenger/trip_history_screen.dart';
import '../features/passenger/profile_screen.dart';

// Map Flow (Faisal)
import '../features/map/live_map_screen.dart';

// Operator Flow (Mutebi)
import '../features/operator/operator_login_screen.dart';

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

    // Map Flow (Faisal)
    GoRoute(
      path: '/live-map',
      name: 'live-map',
      builder: (context, state) => const LiveMapScreen(),
    ),

    // Operator Flow (Mutebi)
    GoRoute(
      path: '/operator-login',
      name: 'operator-login',
      builder: (context, state) => const OperatorLoginScreen(),
    ),
  ],
);
