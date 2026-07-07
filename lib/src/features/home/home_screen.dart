import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Ride UG'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. REAL BUS LOGO (Your image)
              _buildLogo(),
              const SizedBox(height: 16),

              // 2. DYNAMIC WELCOME TEXT
              _buildWelcomeText(),
              const SizedBox(height: 40),

              // 3. PRIMARY GUEST BUTTON (Big, Blue)
              _buildGuestButton(context),
              const SizedBox(height: 12),

              // 4. SECONDARY SIGN-IN OPTION (Small text)
              _buildSignInOption(context),
              const SizedBox(height: 40),

              // 5. HIDDEN OPERATOR ACCESS (Subtle & safe)
              _buildOperatorAccess(context),
            ],
          ),
        ),
      ),
    );
  }

  // ========== 1. LOGO WIDGET ==========
  Widget _buildLogo() {
    return Image.asset(
      'assets/images/bus_logo.png',
      width: 150,
      height: 150,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback in case image is missing
        return Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.directions_bus, size: 80, color: Colors.blue),
        );
      },
    );
  }

  // ========== 2. WELCOME TEXT ==========
  Widget _buildWelcomeText() {
    return const Column(
      children: [
        Text(
          'Welcome, Guest!',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          'Where are you heading today?',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  // ========== 3. GUEST MODE (Primary Action) ==========
  Widget _buildGuestButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          // TODO: Navigate to Passenger Map (Guest Mode)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🚍 Entering Passenger Portal as Guest...'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: const Text(
          '🚍 Find My Bus (Guest)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ========== 4. SIGN-IN OPTION (Subtle) ==========
  Widget _buildSignInOption(BuildContext context) {
    return TextButton(
      onPressed: () {
        // TODO: Navigate to Login/Signup
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('📝 Opening Sign In...'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: const Text(
        'Sign in for saved routes & trip history',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  }

  // ========== 5. HIDDEN OPERATOR ACCESS (Secure & Subtle) ==========
  Widget _buildOperatorAccess(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to Operator Login (hidden)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🔐 Operator Access Triggered'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          '🔧 Staff Access',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}
