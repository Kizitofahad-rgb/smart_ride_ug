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

  final List<Map<String, dynamic>> _stats = [
    {'label': 'Total Buses', 'value': '12', 'badge': 'Live'},
    {'label': 'Active Trips', 'value': '8', 'badge': 'Stable'},
    {'label': 'Open Requests', 'value': '5', 'badge': 'Pending'},
  ];

  final List<Map<String, dynamic>> _busList = [
    {
      'id': 'KGL-001',
      'route': 'Kampala → Masaka',
      'status': 'In Service',
      'statusType': BadgeStatus.active,
      'occupancy': '18/24',
    },
    {
      'id': 'EBB-014',
      'route': 'Entebbe → Jinja',
      'status': 'Delayed',
      'statusType': BadgeStatus.warning,
      'occupancy': '12/24',
    },
    {
      'id': 'KLA-234',
      'route': 'Kampala → Mukono',
      'status': 'Maintenance',
      'statusType': BadgeStatus.error,
      'occupancy': '0/24',
    },
  ];

  final List<Map<String, dynamic>> _bookingRequests = [
    {
      'id': 'REQ-221',
      'from': 'Kampala',
      'to': 'Masaka',
      'passengers': '4',
      'fare': 'UGX 24,000',
      'status': 'Pending',
      'statusType': BadgeStatus.warning,
    },
    {
      'id': 'REQ-222',
      'from': 'Entebbe',
      'to': 'Jinja',
      'passengers': '2',
      'fare': 'UGX 14,500',
      'status': 'Pending',
      'statusType': BadgeStatus.warning,
    },
  ];

  final List<Map<String, dynamic>> _passengers = [
    {
      'name': 'Amina Mukasa',
      'phone': '+256 772 123 456',
      'recentTrip': 'Kampala → Masaka',
      'status': BadgeStatus.active,
    },
    {
      'name': 'John Kato',
      'phone': '+256 700 987 654',
      'recentTrip': 'Entebbe → Jinja',
      'status': BadgeStatus.active,
    },
    {
      'name': 'Sarah Nambi',
      'phone': '+256 755 321 987',
      'recentTrip': 'Kampala → Mukono',
      'status': BadgeStatus.inactive,
    },
  ];

  final List<Map<String, String>> _notifications = [
    {'title': 'New booking request received', 'time': '2 mins ago'},
    {'title': 'Bus KGL-001 left Old Taxi Park', 'time': '15 mins ago'},
    {'title': 'Trip request approved', 'time': '40 mins ago'},
  ];

  void _updateRequestStatus(int index, String status) {
    setState(() {
      _bookingRequests[index]['status'] = status;
      _bookingRequests[index]['statusType'] = status == 'Approved'
          ? BadgeStatus.active
          : BadgeStatus.error;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 1:
        return _buildBusStatusScreen();
      case 2:
        return _buildRequestScreen();
      case 3:
        return _buildPassengerScreen();
      default:
        return _buildDashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? 'Dashboard'
              : _selectedIndex == 1
              ? 'Bus Status'
              : _selectedIndex == 2
              ? 'Booking Requests'
              : 'Passengers',
          style: AppTextStyles.heading.copyWith(color: AppColors.primary),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: _buildBody(),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Passengers',
          ),
        ],
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }

  Widget _buildDashboardScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 600;
              final cardWidth = isCompact
                  ? (constraints.maxWidth - 12) / 2
                  : (constraints.maxWidth - 24) / 3;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                // 🔥 FIXED: Added .toList() to convert Iterable to List
                children: _stats
                    .map(
                      (item) => SizedBox(
                        width: cardWidth,
                        child: CustomCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['label'], style: AppTextStyles.caption),
                              const SizedBox(height: 8),
                              Text(item['value'], style: AppTextStyles.heading),
                              const SizedBox(height: 8),
                              StatusBadge(
                                label: item['badge'],
                                status: item['badge'] == 'Stable'
                                    ? BadgeStatus.active
                                    : item['badge'] == 'Pending'
                                    ? BadgeStatus.warning
                                    : BadgeStatus.active,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(), // 🔥 This is the fix!
              );
            },
          ),
          const SizedBox(height: 16),
          CustomCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Notifications', style: AppTextStyles.subheading),
                const SizedBox(height: 12),
                ..._notifications.map((note) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            note['title']!,
                            style: AppTextStyles.body,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(note['time']!, style: AppTextStyles.caption),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CustomCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recent Activity', style: AppTextStyles.subheading),
                const SizedBox(height: 12),
                ..._buildActivityList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusStatusScreen() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _busList.length,
      itemBuilder: (context, index) {
        final bus = _busList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CustomCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(bus['id'], style: AppTextStyles.subheading),
                    ),
                    const SizedBox(width: 12),
                    StatusBadge(
                      label: bus['status'],
                      status: bus['statusType'],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(bus['route'], style: AppTextStyles.body),
                const SizedBox(height: 8),
                Text(
                  'Occupancy: ${bus['occupancy']}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequestScreen() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _bookingRequests.length,
      itemBuilder: (context, index) {
        final request = _bookingRequests[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CustomCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        request['id'],
                        style: AppTextStyles.subheading,
                      ),
                    ),
                    const SizedBox(width: 12),
                    StatusBadge(
                      label: request['status'],
                      status: request['statusType'],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${request['from']} → ${request['to']}',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 4),
                Text(
                  '${request['passengers']} passengers • ${request['fare']}',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 12),
                if (request['status'] == 'Pending')
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () =>
                              _updateRequestStatus(index, 'Approved'),
                          child: const Text('Approve'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: BorderSide(color: AppColors.error),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () =>
                              _updateRequestStatus(index, 'Cancelled'),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPassengerScreen() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _passengers.length,
      itemBuilder: (context, index) {
        final passenger = _passengers[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CustomCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(passenger['name'], style: AppTextStyles.subheading),
                      const SizedBox(height: 6),
                      Text(passenger['phone'], style: AppTextStyles.body),
                      const SizedBox(height: 6),
                      Text(
                        'Recent trip: ${passenger['recentTrip']}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                StatusBadge(
                  label: passenger['status'] == BadgeStatus.active
                      ? 'Active'
                      : 'Inactive',
                  status: passenger['status'] as BadgeStatus,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildActivityList() {
    final activities = [
      {'action': 'Bus #KGL-001 departed', 'time': '2 mins ago'},
      {'action': 'New request from Kampala', 'time': '15 mins ago'},
      {'action': 'Trip request approved', 'time': '35 mins ago'},
    ];

    return activities
        .map(
          (a) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CustomCard(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(a['action']!, style: AppTextStyles.body),
                  ),
                  const SizedBox(width: 12),
                  Text(a['time']!, style: AppTextStyles.caption),
                ],
              ),
            ),
          ),
        )
        .toList();
  }
}
