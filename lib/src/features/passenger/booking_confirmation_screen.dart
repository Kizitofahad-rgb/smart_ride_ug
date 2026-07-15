import 'package:flutter/material.dart';
import 'reservation_countdown_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String pickupLocation;
  final String destinationLocation;
  final String seat;

  const BookingConfirmationScreen({
    Key? key,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.seat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Booking Confirmed', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Center(
              child: Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 90),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Booking Successful',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            const Center(
              child: Text(
                'Your seat has been reserved',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow(Icons.my_location, 'Pickup', pickupLocation, const Color(0xFF38BDF8)),
                  const Divider(color: Colors.grey, height: 24),
                  _buildDetailRow(Icons.location_on, 'Destination', destinationLocation, const Color(0xFF2563EB)),
                  const Divider(color: Colors.grey, height: 24),
                  _buildDetailRow(Icons.event_seat, 'Seat', seat, const Color(0xFFF59E0B)),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReservationCountdownScreen(),
                  ),
                );
              },
              child: const Text('Continue', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}