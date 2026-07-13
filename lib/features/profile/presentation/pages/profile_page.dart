import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../data/repositories/dummy_profile_repository.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

/// Profile tab. Replaces the earlier stub.
///
/// Same BLoC + Repository pattern as Routes/Bus Stops/Search. When
/// Firebase Authentication is integrated (ADR-006), only
/// `DummyProfileRepository` needs to change into something reading
/// `FirebaseAuth.instance.currentUser` — this page stays as-is.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(repository: DummyProfileRepository())
        ..add(const LoadProfile()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            switch (state.status) {
              case ProfileStatus.initial:
              case ProfileStatus.loading:
                return const Center(child: CircularProgressIndicator());

              case ProfileStatus.error:
                return Center(
                  child: Text(state.errorMessage ?? 'Something went wrong.'),
                );

              case ProfileStatus.loaded:
                final profile = state.profile!;

                return ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              profile.fullName.isNotEmpty
                                  ? profile.fullName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            profile.fullName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Member since ${profile.memberSince}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    _ProfileInfoTile(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: profile.email,
                    ),
                    _ProfileInfoTile(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: profile.phoneNumber,
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    const _ProfileMenuTile(
                      icon: Icons.edit_outlined,
                      label: 'Edit Profile',
                    ),
                    const _ProfileMenuTile(
                      icon: Icons.bookmark_outline,
                      label: 'Saved Places',
                    ),
                    const _ProfileMenuTile(
                      icon: Icons.notifications_outlined,
                      label: 'Notification Settings',
                    ),
                    const _ProfileMenuTile(
                      icon: Icons.logout,
                      label: 'Log Out',
                      isDestructive: true,
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.textPrimary;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: () {
        // TODO: wire up once the relevant feature/screen exists.
      },
    );
  }
}