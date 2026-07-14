import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/auth_service.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int? _selectedSeat;
  final List<String> _seats = ['1A', '1B', '1C', '1D', '2A', '2B', '2C', '2D'];
  final List<int> _occupiedSeats = [2, 5]; // example occupied seat indexes

  void _handleBooking(BuildContext context) {
    if (!AuthService.instance.isAuthenticated) {
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
      return;
    }

    if (_selectedSeat == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Seat ${_seats[_selectedSeat!]} booked successfully!'),
        backgroundColor: const Color(0xFF2563EB),
      ),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape =
              MediaQuery.orientationOf(context) == Orientation.landscape;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              // Pickup location card
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
              // Destination card
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
              // Seat selector grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _seats.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: isLandscape ? 1.35 : 1,
                ),
                itemBuilder: (context, index) {
                  final isOccupied = _occupiedSeats.contains(index);
                  final isSelected = _selectedSeat == index;
                  return GestureDetector(
                    onTap: isOccupied
                        ? null
                        : () {
                            setState(() {
                              _selectedSeat = index;
                            });
                          },
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
              // Book button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _selectedSeat == null
                    ? null
                    : () => _handleBooking(context),
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
