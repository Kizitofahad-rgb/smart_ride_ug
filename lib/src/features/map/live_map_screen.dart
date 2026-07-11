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

  // Null until the passenger taps a station marker to pick a destination.
  // The route polyline and destination pin only render once this is set.
  LatLng? _destination;
  String? _destinationName;

  void _zoomBy(double delta) {
    _currentZoom = (_currentZoom + delta).clamp(12.0, 18.0);
    _mapController.move(_mapController.camera.center, _currentZoom);
  }

  void _onStationTap(String name) {
    final station = RouteLayerManager.stations.firstWhere(
          (s) => s["name"] == name,
    );
    setState(() {
      _destination = LatLng(station["lat"] as double, station["lng"] as double);
      _destinationName = name;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Destination set: $name')),
    );
  }

  void _clearDestination() {
    setState(() {
      _destination = null;
      _destinationName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
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
              // CartoDB Positron tiles — free, no API key, light basemap
              // similar to the standard Google Maps look. Swap the
              // urlTemplate below for plain OSM tiles
              // ('https://tile.openstreetmap.org/{z}/{x}/{y}.png') if you'd
              // rather use the default OSM style.
              TileLayer(
                urlTemplate:
                'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.mhl.smart_ride_ug',
                maxZoom: 20,
              ),
              // Route line only appears once a destination has been chosen.
              if (_destination != null)
                RouteLayerManager.buildRoutePolylineLayer(),
              RouteLayerManager.buildStationMarkerLayer(
                onStationTap: _onStationTap,
              ),
              MarkerLayer(
                markers: [
                  RouteLayerManager.buildBusMarker(_kampalaCenter),
                  if (_destination != null)
                    RouteLayerManager.buildDestinationMarker(_destination!),
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
          if (_destinationName != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFFEF4444), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'To: $_destinationName',
                          style: const TextStyle(
                            color: Color(0xFF1E293B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _clearDestination,
                        child: const Icon(Icons.close, color: Color(0xFF64748B), size: 20),
                      ),
                    ],
                  ),
                ),
              ),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF1E293B), size: 20),
      ),
    );
  }
}