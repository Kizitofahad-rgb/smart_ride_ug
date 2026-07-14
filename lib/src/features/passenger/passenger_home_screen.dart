import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'booking_screen.dart';
import 'trip_history_screen.dart';
import 'profile_screen.dart';
import '../map/live_map_screen.dart';

class PassengerHomeScreen extends StatelessWidget {
  const PassengerHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = AuthService.instance.isAuthenticated;
    final userName = AuthService.instance.userName ?? 'Guest';
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Smart Ride UG',
                style: AppTextStyles.heading.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 8),
              Text(
                isAuthenticated
                    ? 'Welcome back, $userName'
                    : 'Browse routes and preview the app as a guest',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LiveMapScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Find My Bus',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (!AuthService.instance.isAuthenticated) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please sign in or register to book a seat.',
                              ),
                            ),
                          );
                          context.push('/passenger-login');
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookingScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Book Seat',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TripHistoryScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Trip History',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: const Color(0xFF38BDF8),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TripHistoryScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Trips'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
