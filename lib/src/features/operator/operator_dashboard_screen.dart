import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/status_badge.dart';

class OperatorDashboardScreen extends StatefulWidget {
  const OperatorDashboardScreen({super.key});

  @override
  State<OperatorDashboardScreen> createState() =>
      _OperatorDashboardScreenState();
}

class _OperatorDashboardScreenState extends State<OperatorDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Buses', style: AppTextStyles.caption),
                        const SizedBox(height: 8),
                        Text('12', style: AppTextStyles.heading),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Active Trips', style: AppTextStyles.caption),
                        const SizedBox(height: 8),
                        Text('8', style: AppTextStyles.heading),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Passenger Requests Card
            CustomCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Passenger Requests', style: AppTextStyles.subheading),
                  const SizedBox(height: 12),
                  ..._buildRequestList(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Revenue Card
            CustomCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Today\'s Revenue', style: AppTextStyles.subheading),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'UGX 2,450,000',
                        style: AppTextStyles.heading.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                      const StatusBadge(
                        label: 'On Track',
                        status: BadgeStatus.active,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Recent Activity
            Text('Recent Activity', style: AppTextStyles.subheading),
            const SizedBox(height: 12),
            ..._buildActivityList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.muted,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Buses',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Requests'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }

  List<Widget> _buildRequestList() {
    final requests = [
      {
        'from': 'Kampala',
        'to': 'Masaka',
        'passengers': '4',
        'status': BadgeStatus.active,
      },
      {
        'from': 'Entebbe',
        'to': 'Jinja',
        'passengers': '2',
        'status': BadgeStatus.warning,
      },
    ];

    return requests
        .map(
          (r) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${r['from']} → ${r['to']}',
                      style: AppTextStyles.body,
                    ),
                    Text(
                      '${r['passengers']} passengers',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                StatusBadge(
                  label: (r['status'] as BadgeStatus) == BadgeStatus.active
                      ? 'Active'
                      : 'Waiting',
                  status: r['status'] as BadgeStatus,
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  List<Widget> _buildActivityList() {
    final activities = [
      {'action': 'Bus #KGL-001 departed', 'time': '2 mins ago'},
      {'action': 'New request from Kampala', 'time': '15 mins ago'},
      {'action': 'Trip #TR-245 completed', 'time': '35 mins ago'},
    ];

    return activities
        .map(
          (a) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CustomCard(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(a['action']!, style: AppTextStyles.body),
                  ),
                  Text(a['time']!, style: AppTextStyles.caption),
                ],
              ),
            ),
          ),
        )
        .toList();
  }
}
