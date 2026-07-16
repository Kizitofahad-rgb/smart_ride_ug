import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/services/auth_service.dart';
import '../../services/firebase/firestore_service.dart';

class BookingScreen extends StatefulWidget {
  // 🔥 NEW: Accept data via constructor
  final String busId;
  final String routeName;
  final int availableSeats;
  final String eta;

  const BookingScreen({
    super.key,
    this.busId = 'BUS-001',
    this.routeName = 'Route 4A - Kampala Loop',
    this.availableSeats = 40,
    this.eta = '~5 min',
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int? _selectedSeat;
  final List<String> _seats = ['1A', '1B', '1C', '1D', '2A', '2B', '2C', '2D'];
  final List<int> _occupiedSeats = [2, 5];
  bool _isBooking = false;

  Future<void> _handleBooking(BuildContext context) async {
    if (!AuthService.instance.isAuthenticated) {
      _showAuthDialog(context);
      return;
    }

    if (_selectedSeat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a seat first')),
      );
      return;
    }

    final userId = AuthService.instance.currentUserId;
    if (userId == null) {
      _showAuthDialog(context);
      return;
    }

    setState(() => _isBooking = true);

    try {
      final bookingData = {
        'userId': userId,
        'busId': widget.busId,
        'routeName': widget.routeName,
        'pickup': 'Old Taxi Park',
        'destination': 'Makerere University',
        'seat': _seats[_selectedSeat!],
        'seats': 1,
        'status': 'pending',
        'confirmed': false,
        'eta': widget.eta,
        'createdAt': FieldValue.serverTimestamp(),
      };

      final bookingId = await FirestoreService().createBooking(bookingData);

      await FirebaseFirestore.instance.collection('trips').add({
        'userId': userId,
        'bookingId': bookingId,
        'busId': widget.busId,
        'routeName': widget.routeName,
        'pickup': 'Old Taxi Park',
        'destination': 'Makerere University',
        'seat': _seats[_selectedSeat!],
        'seats': 1,
        'status': 'pending',
        'eta': widget.eta,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('buses')
          .doc(widget.busId)
          .update({
            'availableSeats': FieldValue.increment(-1),
            'lastUpdated': FieldValue.serverTimestamp(),
          });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ Seat ${_seats[_selectedSeat!]} booked successfully!',
          ),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/history');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '❌ Booking failed: ${e.toString().replaceFirst('Exception: ', '')}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => _isBooking = false);
  }

  void _showAuthDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111827),
          title: const Text(
            'Sign in required',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'You must sign in or register before booking a seat.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/passenger-login');
              },
              child: const Text('Sign In'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/passenger-register');
              },
              child: const Text('Register'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text(
          'Book Your Seat',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Bus Info Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2563EB), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.directions_bus, color: Color(0xFF2563EB)),
                    const SizedBox(width: 8),
                    Text(
                      widget.busId,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'ETA: ${widget.eta}',
                        style: const TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.routeName,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.event_seat,
                      color: Color(0xFF38BDF8),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.availableSeats} seats available',
                      style: const TextStyle(
                        color: Color(0xFF38BDF8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Pickup
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.my_location, color: Color(0xFF38BDF8)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Old Taxi Park',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Destination
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF2563EB)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Makerere University',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Select Your Seat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _seats.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final isOccupied = _occupiedSeats.contains(index);
              final isSelected = _selectedSeat == index;
              return GestureDetector(
                onTap: isOccupied
                    ? null
                    : () => setState(() => _selectedSeat = index),
                child: Container(
                  decoration: BoxDecoration(
                    color: isOccupied
                        ? Colors.grey[700]
                        : isSelected
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      _seats[index],
                      style: TextStyle(
                        color: isOccupied ? Colors.grey[400] : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: (_selectedSeat == null || _isBooking)
                ? null
                : () => _handleBooking(context),
            child: _isBooking
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Confirm Booking',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ],
      ),
    );
  }
}
