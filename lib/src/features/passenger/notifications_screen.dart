import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data for now — will be replaced with real Firebase notifications
    final List<Map<String, String>> _mockNotifications = [
      {
        'title': 'Booking Confirmed',
        'subtitle': 'Your seat 1A has been reserved for Old Taxi Park → Makerere University',
        'time': '2m ago',
      },
      {
        'title': 'Bus Arriving Soon',
        'subtitle': 'Your bus is 5 minutes away from the pickup point',
        'time': '10m ago',
      },
      {
        'title': 'Payment Successful',
        'subtitle': 'Your payment of UGX 3,000 was received',
        'time': '1h ago',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: _mockNotifications.isEmpty
          ? const Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: _mockNotifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notification = _mockNotifications[index];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF2563EB),
                      child: Icon(Icons.notifications, color: Colors.white),
                    ),
                    title: Text(
                      notification['title'] ?? '',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      notification['subtitle'] ?? '',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    trailing: Text(
                      notification['time'] ?? '',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                );
              },
            ),
    );
  }
}