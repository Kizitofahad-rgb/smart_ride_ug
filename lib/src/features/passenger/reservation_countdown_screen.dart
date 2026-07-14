import 'dart:async';
import 'package:flutter/material.dart';

class ReservationCountdownScreen extends StatefulWidget {
  const ReservationCountdownScreen({Key? key}) : super(key: key);

  @override
  State<ReservationCountdownScreen> createState() => _ReservationCountdownScreenState();
}

class _ReservationCountdownScreenState extends State<ReservationCountdownScreen> {
  static const int _startSeconds = 59;
  int _secondsRemaining = _startSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 0) {
        timer.cancel();
        // TODO: Navigate to reservation_expired_screen.dart once it exists
        return;
      }
      setState(() {
        _secondsRemaining--;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isExpiring = _secondsRemaining <= 10;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Seat Reserved', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_seat, color: const Color(0xFF38BDF8), size: 70),
            const SizedBox(height: 16),
            const Text(
              'Seat Reserved',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Complete payment before the timer runs out',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E293B),
                border: Border.all(
                  color: isExpiring ? const Color(0xFFEF4444) : const Color(0xFF2563EB),
                  width: 4,
                ),
              ),
              child: Center(
                child: Text(
                  '$_secondsRemaining',
                  style: TextStyle(
                    color: isExpiring ? const Color(0xFFEF4444) : Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Time Remaining (seconds)',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                // TODO: Hook up to payment flow when ready
              },
              child: const Text('Pay Now', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}