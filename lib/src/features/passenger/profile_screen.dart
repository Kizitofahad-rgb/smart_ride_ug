import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Loading...';
  String _email = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = AuthService.instance.currentUser;
    if (user == null) {
      setState(() {
        _name = 'Not signed in';
        _isLoading = false;
      });
      return;
    }

    try {
      final name = await AuthService.instance.getUserName();
      setState(() {
        _name =
            name ?? user.displayName ?? user.email?.split('@').first ?? 'User';
        _email = user.email ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _name = user.displayName ?? user.email?.split('@').first ?? 'User';
        _email = user.email ?? '';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color background = theme.colorScheme.background;
    final Color surface = theme.colorScheme.surface;
    final Color textPrimary = theme.colorScheme.onBackground;
    final Color textSecondary = theme.colorScheme.onBackground.withOpacity(0.7);
    final Color accent = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: surface,
        elevation: 0,
        centerTitle: true,
        foregroundColor: textPrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
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
                        _name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _email,
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
                        title: Text(
                          'Settings',
                          style: TextStyle(color: textPrimary),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: textSecondary,
                        ),
                        onTap: () {},
                      ),
                      Divider(color: theme.dividerColor),
                      ListTile(
                        leading: Icon(Icons.help_outline, color: accent),
                        title: Text(
                          'Help & Support',
                          style: TextStyle(color: textPrimary),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: textSecondary,
                        ),
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
                    onPressed: () async {
                      await AuthService.instance.signOut();
                      if (context.mounted) {
                        context.go('/');
                      }
                    },
                    child: const Text('Logout'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }
}
