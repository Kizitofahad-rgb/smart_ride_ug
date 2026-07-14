import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color background = theme.colorScheme.background;
    final Color surface = theme.colorScheme.surface;
    final Color textPrimary = theme.colorScheme.onBackground;
    final Color textSecondary = theme.colorScheme.onBackground.withOpacity(0.7);
    final Color accent = theme.colorScheme.primary;

    // Simulated user data - replace with real data later
    final String userName = 'Mable';
    final String userEmail = 'mable@smartride.com';
    final String userPhone = '+256 700 123 456';

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: surface,
        elevation: 0,
        centerTitle: true,
        foregroundColor: textPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: accent,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  userName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userPhone,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userEmail,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.settings, color: accent),
                  title: Text('Settings', style: TextStyle(color: textPrimary)),
                  trailing: Icon(Icons.chevron_right, color: textSecondary),
                  onTap: () {},
                ),
                Divider(color: theme.dividerColor),
                ListTile(
                  leading: Icon(Icons.help_outline, color: accent),
                  title: Text(
                    'Help & Support',
                    style: TextStyle(color: textPrimary),
                  ),
                  trailing: Icon(Icons.chevron_right, color: textSecondary),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: const Text('Logout'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
