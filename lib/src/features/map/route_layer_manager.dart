import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RouteLayerManager {
  // Simulating route sequence from Kampala Center through Wandegeya to Makerere Main Gate
  static List<LatLng> getMainRouteCoordinates() {
    return const [
      LatLng(0.3136, 32.5811), // Kampala Central Node
      LatLng(0.3220, 32.5760), // Wandegeya Intersection
      LatLng(0.3292, 32.5711), // Makerere Main Gate Station
      LatLng(0.3340, 32.5675), // CoCIS Complex Terminal
    ];
  }

  static PolylineLayer buildRoutePolylineLayer() {
    return PolylineLayer(
      polylines: [
        Polyline(
          points: getMainRouteCoordinates(),
          strokeWidth: 4,
          color: const Color(0xFF2563EB), // Primary Accent Blue
        ),
      ],
    );
  }

  static MarkerLayer buildStationMarkerLayer({
    required void Function(String) onStationTap,
  }) {
    final stations = [
      {"name": "Wandegeya Stop", "lat": 0.3220, "lng": 32.5760},
      {"name": "Makerere Gate Hub", "lat": 0.3292, "lng": 32.5711},
    ];

    return MarkerLayer(
      markers: stations.map((station) {
        final name = station["name"] as String;
        return Marker(
          point: LatLng(station["lat"] as double, station["lng"] as double),
          width: 30,
          height: 30,
          child: GestureDetector(
            onTap: () => onStationTap(name),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF64748B),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.directions_bus_filled,
                color: Color(0xFF64748B),
                size: 16,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// The live bus marker: blue circle (20% opacity), green border, blue bus
  /// glyph. Position updates simply by rebuilding this with a new [position].
  static Marker buildBusMarker(LatLng position) {
    return Marker(
      point: position,
      width: 40,
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2563EB).withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF10B981),
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.directions_bus,
          color: Color(0xFF2563EB),
          size: 22,
        ),
      ),
    );
  }
}