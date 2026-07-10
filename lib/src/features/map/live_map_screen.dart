import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'route_layer_manager.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  GoogleMapController? _mapController;

  static const LatLng _kampalaCenter = LatLng(0.3292, 32.5711);
  double _currentZoom = 15.0;

  static const String _darkMapStyle = '''
  [
    {"elementType": "geometry", "stylers": [{"color": "#0F172A"}]},
    {"elementType": "labels.text.stroke", "stylers": [{"color": "#0F172A"}]},
    {"elementType": "labels.text.fill", "stylers": [{"color": "#8ec3b9"}]},
    {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#1E293B"}]},
    {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#0b1a2b"}]},
    {"featureType": "poi", "stylers": [{"visibility": "off"}]}
  ]
  ''';

  Set<Marker> get _markers => {
    const Marker(
      markerId: MarkerId('bus_current_position'),
      position: _kampalaCenter,
      icon: BitmapDescriptor.defaultMarker,
    ),
    ...RouteLayerManager.buildStationMarkers(
      onStationTap: (name) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(name)),
        );
      },
    ),
  };

  Future<void> _zoomBy(double delta) async {
    _currentZoom = (_currentZoom + delta).clamp(12.0, 18.0);
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_kampalaCenter, _currentZoom),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _kampalaCenter,
              zoom: _currentZoom,
            ),
            minMaxZoomPreference: const MinMaxZoomPreference(12.0, 18.0),
            style: _darkMapStyle,
            markers: _markers,
            polylines: RouteLayerManager.buildRoutePolylines(),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
            },
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