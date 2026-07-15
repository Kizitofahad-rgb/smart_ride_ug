import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../services/firebase/firestore_service.dart';

class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = AuthService.instance.currentUserId;

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
      body: userId == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, color: Colors.grey, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'Please login to see your trips',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sign in to view your booking history',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            )
          : StreamBuilder(
              stream: FirestoreService().getTripHistory(userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final trips = snapshot.data!.docs;

                if (trips.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_bus,
                          color: Colors.grey,
                          size: 60,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No trips yet',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Text(
                          'Book a seat to get started!',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: trips.length,
                  itemBuilder: (context, index) {
                    final trip = trips[index].data() as Map<String, dynamic>;
                    final tripId = trips[index].id;
                    final isUpcoming =
                        trip['status'] == 'pending' ||
                        trip['status'] == 'approved';
                    final isCompleted = trip['status'] == 'completed';

                    Color statusColor;
                    String statusLabel;

                    if (isUpcoming) {
                      statusColor = const Color(0xFF2563EB);
                      statusLabel = 'Upcoming';
                    } else if (isCompleted) {
                      statusColor = Colors.green[700]!;
                      statusLabel = 'Completed';
                    } else {
                      statusColor = Colors.red[700]!;
                      statusLabel = 'Cancelled';
                    }

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
                                    '${trip['pickup'] ?? 'Unknown'} → ${trip['destination'] ?? 'Unknown'}',
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
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    statusLabel,
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
                              '${trip['seats'] ?? 1} seat(s) • Booking #${tripId.substring(0, 6)}',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Created: ${trip['createdAt']?.toDate()?.toString() ?? 'Just now'}',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
