import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  static Set<Polyline> buildRoutePolylines() {
    return {
      Polyline(
        polylineId: const PolylineId('main_route'),
        points: getMainRouteCoordinates(),
        width: 4,
        color: const Color(0xFF2563EB), // Primary Accent Blue
      ),
    };
  }

  static Set<Marker> buildStationMarkers({
    required void Function(String) onStationTap,
  }) {
    final stations = [
      {"name": "Wandegeya Stop", "lat": 0.3220, "lng": 32.5760},
      {"name": "Makerere Gate Hub", "lat": 0.3292, "lng": 32.5711},
    ];

    return stations.map((station) {
      final name = station["name"] as String;
      return Marker(
        markerId: MarkerId(name),
        position: LatLng(station["lat"] as double, station["lng"] as double),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        ),
        onTap: () => onStationTap(name),
      );
    }).toSet();
  }
}