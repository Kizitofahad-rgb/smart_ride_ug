import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int? _selectedSeat;
  final List<String> _seats = ['1A', '1B', '1C', '1D', '2A', '2B', '2C', '2D'];
  final List<int> _occupiedSeats = [2, 5]; // example occupied seat indexes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Book Your Seat', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: Text('Old Taxi Park', style: TextStyle(color: Colors.white, fontSize: 16)),
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
                    child: Text('Makerere University', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Your Seat',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Seat selector grid
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
            const Spacer(),
            // Book button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _selectedSeat == null
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Seat ${_seats[_selectedSeat!]} booked successfully!'),
                          backgroundColor: const Color(0xFF2563EB),
                        ),
                      );
                    },
              child: const Text('Confirm Booking', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}