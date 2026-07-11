import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'route_layer_manager.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  final MapController _mapController = MapController();

  static const LatLng _kampalaCenter = LatLng(0.3292, 32.5711);
  double _currentZoom = 15.0;

  void _zoomBy(double delta) {
    _currentZoom = (_currentZoom + delta).clamp(12.0, 18.0);
    _mapController.move(_mapController.camera.center, _currentZoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _kampalaCenter,
              initialZoom: _currentZoom,
              minZoom: 12.0,
              maxZoom: 18.0,
            ),
            children: [
              // CartoDB Dark Matter tiles — free, no API key, matches the
              // app's dark theme. Swap the urlTemplate below for standard
              // OSM tiles ('https://tile.openstreetmap.org/{z}/{x}/{y}.png')
              // if you'd rather use the default light OSM style.
              TileLayer(
                urlTemplate:
                'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.mhl.smart_ride_ug',
                maxZoom: 20,
              ),
              RouteLayerManager.buildRoutePolylineLayer(),
              RouteLayerManager.buildStationMarkerLayer(
                onStationTap: (name) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(name)),
                  );
                },
              ),
              MarkerLayer(
                markers: [
                  RouteLayerManager.buildBusMarker(_kampalaCenter),
                ],
              ),
              // Required attribution when using OSM/CartoDB tiles.
              const RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('OpenStreetMap contributors'),
                  TextSourceAttribution('CARTO'),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 24.0,
            right: 16.0,
            child: Column(
              children: [
                _buildZoomButton(icon: Icons.add, onPressed: () => _zoomBy(1)),
                const SizedBox(height: 8),
                _buildZoomButton(icon: Icons.remove, onPressed: () => _zoomBy(-1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}