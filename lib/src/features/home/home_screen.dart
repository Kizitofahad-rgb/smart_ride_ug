import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0E1A), // Deep Navy
              const Color(0xFF1A1A3A), // Dark Purple
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- 1. Floating Logo (Faux 3D effect) ---
                AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 8 * _floatController.value),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade900.withOpacity(0.6),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/bus_logo.png',
                          height: 140,
                          width: 140,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // --- 2. App Title ---
                const Text(
                  'Smart Ride UG',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ).animate().fade(duration: 600.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 8),
                const Text(
                      'Safe. Fast. Reliable.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        letterSpacing: 2,
                      ),
                    )
                    .animate()
                    .fade(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 60),

                // --- 3. Glass-Morphism Cards ---
                _buildNavigationCard(
                      context,
                      icon: Icons.person_outline,
                      title: 'Ride as Guest',
                      subtitle: 'Find buses instantly, no sign-up',
                      onTap: () => context.push('/passenger-home'),
                      isPrimary: true,
                    )
                    .animate()
                    .fade(duration: 600.ms, delay: 400.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 16),

                _buildNavigationCard(
                      context,
                      icon: Icons.bookmark_border,
                      title: 'Sign In',
                      subtitle: 'Access saved routes & history',
                      onTap: () => context.push('/profile'),
                      isPrimary: false,
                    )
                    .animate()
                    .fade(duration: 600.ms, delay: 600.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 40),

                // --- 4. Hidden Operator Access (Subtle) ---
                GestureDetector(
                  onTap: () => context.push('/operator-login'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: const Text(
                      '🔧 Staff Access',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ).animate().fade(duration: 600.ms, delay: 800.ms),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isPrimary
              ? const Color(0xFF2563EB) // Primary Blue
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: isPrimary
              ? null
              : Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isPrimary ? Colors.white : Colors.grey.shade300,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isPrimary ? Colors.white : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isPrimary
                          ? Colors.white.withOpacity(0.8)
                          : Colors.grey.shade500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isPrimary ? Colors.white : Colors.grey.shade500,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
