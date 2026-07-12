import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LiveBusMapScreen extends StatefulWidget {
  const LiveBusMapScreen({Key? key}) : super(key: key);

  @override
  _LiveBusMapScreenState createState() => _LiveBusMapScreenState();
}

class _LiveBusMapScreenState extends State<LiveBusMapScreen> {
  final MapController _mapController = MapController();

  // Core Kampala / Makerere Central Coordinate Points
  final LatLng _kampalaCenter = const LatLng(0.3292, 32.5711);
  double _currentZoom = 15.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Slate Theme Base
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _kampalaCenter,
              zoom: _currentZoom,
              minZoom: 12.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _kampalaCenter,
                    width: 40.0,
                    height: 40.0,
                    builder: (ctx) => Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF10B981), width: 2),
                      ),
                      child: const Icon(
                        Icons.directions_bus,
                        color: const Color(0xFF2563EB),
                        size: 22.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Floating Control Layer
          Positioned(
            bottom: 24.0,
            right: 16.0,
            child: Column(
              children: [
                _buildZoomButton(
                  icon: Icons.add,
                  onPressed: () {
                    _currentZoom = (_currentZoom + 1).clamp(12.0, 18.0);
                    _mapController.move(_mapController.center, _currentZoom);
                  },
                ),
                const SizedBox(height: 8),
                _buildZoomButton(
                  icon: Icons.remove,
                  onPressed: () {
                    _currentZoom = (_currentZoom - 1).clamp(12.0, 18.0);
                    _mapController.move(_mapController.center, _currentZoom);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton({required IconData icon, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3)),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}