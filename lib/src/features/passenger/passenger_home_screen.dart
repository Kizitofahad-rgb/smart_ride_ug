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
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            // Greeting
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAuthenticated ? 'Good Morning, $userName 👋' : 'Good Morning 👋',
                        style: AppTextStyles.heading.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Where would you like to go today?',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary.withOpacity(.1),
                  child: Icon(
                    Icons.person,
                    color: AppColors.primary,
                  ),
                )
              ],
            ),
            const SizedBox(height: 28),

            // Destination Search Card
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              elevation: 2,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LiveMapScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        size: 30,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Where are you going?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Search destination or route",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primary,
                        size: 18,
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            Text(
              "Popular Routes",
              style: AppTextStyles.heading.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _RouteChip("Makerere → Wandegeya"),
                  _RouteChip("Ntinda → City"),
                  _RouteChip("Kireka → CBD"),
                  _RouteChip("Nansana → Kampala"),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Fixed: "Find My Bus" Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
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
                // Add your Find My Bus navigation or action here
              },
              child: const Text(
                'Find My Bus',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),

            // Book Seat Button
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
                      content: Text('Please sign in or register to book a seat.'),
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

            // Trip History Button
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

class _RouteChip extends StatelessWidget {
  final String title;
  const _RouteChip(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffEEF4FF),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
