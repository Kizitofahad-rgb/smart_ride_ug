import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../data/bus_location.dart';
import '../data/bus_tracking_repository.dart';

/// Driver-facing screen. Hardcoded to a single demo bus/route for now —
/// [_busId] / [_routeId] — since the app doesn't have a driver/bus
/// assignment flow yet. Tapping "Start Trip" streams the device's live GPS
/// position into Firestore every time it moves ~5m; the passenger-facing
/// LiveMapScreen picks the updates up in real time via
/// [BusTrackingRepository.watchBus].
class DriverBroadcastScreen extends StatefulWidget {
  const DriverBroadcastScreen({super.key});

  @override
  State<DriverBroadcastScreen> createState() => _DriverBroadcastScreenState();
}

class _DriverBroadcastScreenState extends State<DriverBroadcastScreen> {
  static const String _busId = 'bus-001';
  static const String _routeId = 'wandegeya-makerere';

  final BusTrackingRepository _repository = BusTrackingRepository();
  StreamSubscription<Position>? _positionSubscription;

  bool _isBroadcasting = false;
  Position? _lastPosition;
  String? _statusMessage;

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<bool> _ensurePermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      setState(() => _statusMessage =
      'Location permission is required to broadcast your position.');
      return false;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(
              () => _statusMessage = 'Turn on device location services first.');
      return false;
    }
    return true;
  }

  Future<void> _startTrip() async {
    final granted = await _ensurePermission();
    if (!granted) return;

    setState(() {
      _isBroadcasting = true;
      _statusMessage = 'Broadcasting live location…';
    });

    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // meters — only push a Firestore write on real movement
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: settings).listen(
              (position) async {
            setState(() => _lastPosition = position);
            await _repository.pushLocation(
              busId: _busId,
              routeId: _routeId,
              position: LatLng(position.latitude, position.longitude),
              headingDegrees: position.heading,
              speedKmh: position.speed * 3.6, // m/s -> km/h
              status: BusTrackingStatus.active,
            );
          },
          onError: (Object error) {
            setState(() => _statusMessage = 'Location error: $error');
          },
        );
  }

  Future<void> _endTrip() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    await _repository.markOffline(_busId);
    if (!mounted) return;
    setState(() {
      _isBroadcasting = false;
      _statusMessage = 'Trip ended. Bus marked offline.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        title: const Text('Driver — $_busId'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isBroadcasting
                    ? Icons.wifi_tethering
                    : Icons.wifi_tethering_off,
                color: _isBroadcasting
                    ? const Color(0xFF10B981)
                    : const Color(0xFF64748B),
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                _isBroadcasting ? 'Trip in progress' : 'Trip not started',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              if (_lastPosition != null) ...[
                const SizedBox(height: 8),
                Text(
                  '${_lastPosition!.latitude.toStringAsFixed(5)}, '
                      '${_lastPosition!.longitude.toStringAsFixed(5)} · '
                      '${(_lastPosition!.speed * 3.6).toStringAsFixed(0)} km/h',
                  style: const TextStyle(color: Color(0xFF94A3B8)),
                ),
              ],
              if (_statusMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _statusMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFF59E0B)),
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isBroadcasting
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF2563EB),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _isBroadcasting ? _endTrip : _startTrip,
                child: Text(
                  _isBroadcasting ? 'End Trip' : 'Start Trip',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}