import 'package:flutter/material.dart';

class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example trip data - replace with real data later
    final List<Map<String, dynamic>> trips = [
      {
        'route': 'Route 4A - Old Taxi Park to Makerere',
        'date': 'Today, 12:30 PM',
        'status': 'Upcoming',
        'fare': 'UGX 2,500',
      },
      {
        'route': 'Route 14 - Wandegeya to City Square',
        'date': 'Nov 10, 12:30 PM',
        'status': 'Completed',
        'fare': 'UGX 3,000',
      },
      {
        'route': 'Route 22 - Kyambogo to City Center',
        'date': 'Nov 8, 9:00 AM',
        'status': 'Completed',
        'fare': 'UGX 2,800',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text(
          'Trip History',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: trips.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_bus, color: Colors.grey, size: 60),
                  SizedBox(height: 16),
                  Text(
                    'No trips yet',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                final isUpcoming = trip['status'] == 'Upcoming';
                return Card(
                  color: const Color(0xFF1E293B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                trip['route'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isUpcoming
                                    ? const Color(0xFF2563EB)
                                    : Colors.green[700],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                trip['status'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          trip['date'],
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trip['fare'],
                          style: const TextStyle(
                            color: Color(0xFF38BDF8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
