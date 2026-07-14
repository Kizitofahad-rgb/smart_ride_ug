import 'dart:async'; // <-- THIS FIXES THE "Timer" ERROR!
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

  // --- NEW: Secret Tap Logic ---
  int _tapCounter = 0;
  Timer? _tapTimer;

  void _handleLogoTap() {
    // Cancel the previous timer if it exists (so taps reset the timer)
    _tapTimer?.cancel();

    // Increment the counter
    _tapCounter++;

    // If we hit 5 taps, navigate to Operator Login!
    if (_tapCounter >= 5) {
      // Reset the counter
      _tapCounter = 0;
      // Navigate using GoRouter
      context.push('/operator-login');

      // Show a subtle haptic feedback or snackbar (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🔐 Operator Access Granted'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      // If we haven't hit 5 yet, set a timer to reset the counter
      // If the user stops tapping for 1 second, the count resets to 0.
      _tapTimer = Timer(const Duration(seconds: 1), () {
        setState(() {
          _tapCounter = 0;
        });
      });
    }
  }

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
    _tapTimer?.cancel(); // Clean up the timer when the screen is destroyed
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 600;
              final logoSize = compact ? 100.0 : 140.0;
              final horizontalPadding = constraints.maxWidth < 360
                  ? 16.0
                  : 28.0;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // --- 1. SECRET TAP LOGO (Now wrapped with GestureDetector) ---
                      GestureDetector(
                        onTap: _handleLogoTap, // <-- The magic happens here!
                        child: AnimatedBuilder(
                          animation: _floatController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, 8 * _floatController.value),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.shade900.withValues(
                                        alpha: 0.6,
                                      ),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'assets/images/bus_logo.png',
                                  height: logoSize,
                                  width: logoSize,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: compact ? 16 : 24),

                      // --- 2. App Title ---
                      const Text(
                            'Smart Ride UG',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          )
                          .animate()
                          .fade(duration: 600.ms)
                          .slideY(begin: 0.2, end: 0),
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
                      SizedBox(height: compact ? 28 : 60),

                      // --- 3. Glass-Morphism Cards ---
                      _buildNavigationCard(
                            context,
                            icon: Icons.person_outline,
                            title: 'Ride as Guest',
                            subtitle: 'Browse and preview without booking',
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
                            subtitle: 'Access your passenger account',
                            onTap: () => context.push('/passenger-login'),
                            isPrimary: false,
                          )
                          .animate()
                          .fade(duration: 600.ms, delay: 600.ms)
                          .slideY(begin: 0.3, end: 0),

                      // --- 4. OPERATOR ACCESS IS COMPLETELY REMOVED FROM HERE ---
                      // The visible "🔧 Staff Access" text is GONE.
                      // Only the Secret Tap on the logo can open the Operator Portal.
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
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
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: isPrimary
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.4),
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
                          ? Colors.white.withValues(alpha: 0.8)
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
