import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_card.dart';

class PassengerRegisterScreen extends StatefulWidget {
  const PassengerRegisterScreen({super.key});

  @override
  State<PassengerRegisterScreen> createState() =>
      _PassengerRegisterScreenState();
}

class _PassengerRegisterScreenState extends State<PassengerRegisterScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields.')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      AuthService.instance.register(name, email);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration successful!')));
      context.go('/passenger-home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Passenger Register'),
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
              Text('Create your account', style: AppTextStyles.heading),
              const SizedBox(height: 8),
              Text(
                'Register once and use your passenger account every time.',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 40),
              CustomCard(
                color: AppColors.surfaceDark,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Full Name', style: AppTextStyles.subheading),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Your full name',
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
                    const SizedBox(height: 20),
                    Text('Confirm Password', style: AppTextStyles.subheading),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _confirmPasswordController,
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
                  label: _isLoading ? 'Registering...' : 'Register',
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: () => context.go('/passenger-login'),
                  child: const Text('Already have an account? Sign in'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
