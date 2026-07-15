import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_card.dart';

class PassengerLoginScreen extends StatefulWidget {
  const PassengerLoginScreen({super.key});

  @override
  State<PassengerLoginScreen> createState() => _PassengerLoginScreenState();
}

class _PassengerLoginScreenState extends State<PassengerLoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      AuthService.instance.signIn(_emailController.text.trim());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login successful!')));
      context.go('/passenger-home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Passenger Sign In'),
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text('Welcome back', style: AppTextStyles.heading),
              const SizedBox(height: 8),
              Text(
                'Sign in to manage your bookings and trips.',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 40),
              CustomCard(
                color: AppColors.surfaceDark,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email', style: AppTextStyles.subheading),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'you@example.com',
                        hintStyle: AppTextStyles.caption,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Password', style: AppTextStyles.subheading),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: AppTextStyles.caption,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: _isLoading ? 'Signing in...' : 'Sign In',
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: () => context.go('/passenger-register'),
                  child: const Text('Don\'t have an account? Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
