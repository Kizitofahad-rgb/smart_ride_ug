import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'data/bus_location.dart';
import 'data/stop.dart';

class RouteLayerManager {
  // Kampala Central -> Wandegeya -> Makerere Main Gate -> CoCIS Complex.
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
          color: const Color(
            0xFF38BDF8,
          ), // Bright accent blue, readable on dark tiles
        ),
      ],
    );
  }

  /// The stations available for selection as a destination. Exposed as a
  /// static list so the screen can look up a station's LatLng by name when
  /// the user taps a marker.
  static const List<Map<String, Object>> stations = [
    {"name": "Wandegeya Stop", "lat": 0.3220, "lng": 32.5760},
    {"name": "Makerere Gate Hub", "lat": 0.3292, "lng": 32.5711},
  ];

  static MarkerLayer buildStationMarkerLayer({
    required void Function(String) onStationTap,
  }) {
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
                border: Border.all(color: const Color(0xFF94A3B8), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.directions_bus_filled,
                color: Color(0xFFCBD5E1),
                size: 16,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 🔥 FIXED: Added missing method for RouteDetailScreen
  static MarkerLayer buildStopMarkerLayer({
    required List<Stop> stops,
    String? highlightedStopId,
  }) {
    return MarkerLayer(
      markers: stops.map((stop) {
        final isHighlighted = stop.id == highlightedStopId;
        return Marker(
          point: stop.position,
          width: 32,
          height: 32,
          child: Container(
            decoration: BoxDecoration(
              color: isHighlighted
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF1E293B),
              shape: BoxShape.circle,
              border: Border.all(
                color: isHighlighted
                    ? const Color(0xFF60A5FA)
                    : const Color(0xFF94A3B8),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                stop.name.substring(0, 1),
                style: TextStyle(
                  color: isHighlighted ? Colors.white : Colors.grey[400],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 🔥 FIXED: Added missing method for RouteDetailScreen
  static Marker buildUserLocationMarker(LatLng position) {
    return Marker(
      point: position,
      width: 30,
      height: 30,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2563EB).withValues(alpha: 0.3),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF2563EB), width: 2),
        ),
        child: const Center(
          child: Icon(Icons.circle, color: Color(0xFF2563EB), size: 12),
        ),
      ),
    );
  }

  /// A pin marker for the destination the passenger has selected. Only
  /// meant to be added to the map once a destination has been chosen.
  static Marker buildDestinationMarker(LatLng position) {
    return Marker(
      point: position,
      width: 36,
      height: 36,
      alignment: Alignment.topCenter,
      child: const Icon(Icons.location_on, color: Color(0xFFEF4444), size: 36),
    );
  }

  /// The live bus marker. Color reflects [status]/[hasArrived] so the
  /// "arrival" state is visible on the map itself, not just in a banner:
  /// green = active & en route, amber = arrived, grey = stale/offline.
  /// Tap handling is left to the caller (wrap in a GestureDetector) so the
  /// marker itself stays a dumb, reusable piece of UI.
  static Marker buildBusMarker(
    LatLng position, {
    required BusTrackingStatus status,
    required bool hasArrived,
    VoidCallback? onTap,
  }) {
    final Color borderColor;
    if (status == BusTrackingStatus.offline) {
      borderColor = const Color(0xFF64748B); // grey — offline
    } else if (hasArrived) {
      borderColor = const Color(0xFFF59E0B); // amber — arrived
    } else {
      borderColor = const Color(0xFF10B981); // green — active
    }

    return Marker(
      point: position,
      width: 44,
      height: 44,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withValues(alpha: 0.25),
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2.5),
          ),
          child: const Icon(
            Icons.directions_bus,
            color: Color(0xFF60A5FA),
            size: 22,
          ),
        ),
      ),
    );
  }
}
