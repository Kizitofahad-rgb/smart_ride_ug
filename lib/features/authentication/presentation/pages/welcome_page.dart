import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),

              const Icon(
                Icons.directions_bus_rounded,
                size: 130,
                color: Colors.green,
              ),

              const SizedBox(height: AppSpacing.xl),

              const Text(
                AppStrings.welcomeTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              const Text(
                AppStrings.welcomeDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.5,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRouter.register,
                    );
                  },
                  child: const Text("Get Started"),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.login,
                  );
                },
                child: const Text("Sign In"),
              ),

              const SizedBox(height: AppSpacing.md),

              OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRouter.home,
                  );
                },
                child: const Text("Continue as Guest"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}