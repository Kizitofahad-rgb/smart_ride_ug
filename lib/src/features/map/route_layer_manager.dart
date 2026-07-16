import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'data/bus_location.dart';
import 'data/bus_route.dart';
import 'data/stop.dart';

class RouteLayerManager {
  /// The route line itself. Prefers the route's own [BusRoute.polyline]
  /// (denser, road-following points); falls back to straight lines between
  /// [fallbackStops] when a route hasn't had a polyline curated for it yet.
  static Polyline buildRoutePolyline(
      BusRoute route, {
        List<Stop> fallbackStops = const [],
      }) {
    final points = route.polyline.isNotEmpty
        ? route.polyline
        : fallbackStops.map((s) => s.position).toList(growable: false);

    return Polyline(
      points: points,
      color: Color(route.colorValue).withValues(alpha: 0.85),
      strokeWidth: 4,
      borderColor: Colors.black.withValues(alpha: 0.25),
      borderStrokeWidth: 1,
    );
  }

  /// Renders a route's stops. Used two ways:
  /// - [RouteDetailScreen]: no [onStopTap], [highlightedStopId] marks the
  ///   passenger's nearest stop.
  /// - [LiveMapScreen]: [onStopTap] lets the passenger tap a stop to set it
  ///   as the destination for distance/ETA.
  static MarkerLayer buildStopMarkerLayer({
    required List<Stop> stops,
    void Function(Stop)? onStopTap,
    String? highlightedStopId,
  }) {
    return MarkerLayer(
      markers: stops.map((stop) {
        final isHighlighted = stop.id == highlightedStopId;
        return Marker(
          point: stop.position,
          width: isHighlighted ? 36 : 30,
          height: isHighlighted ? 36 : 30,
          child: GestureDetector(
            onTap: onStopTap == null ? null : () => onStopTap(stop),
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
                  width: isHighlighted ? 2.5 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.directions_bus_filled,
                color: isHighlighted ? Colors.white : const Color(0xFFCBD5E1),
                size: isHighlighted ? 18 : 16,
              ),
            ),
          ),
        );
      }).toList(),
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
      child: const Icon(
        Icons.location_on,
        color: Color(0xFFEF4444),
        size: 36,
      ),
    );
  }

  /// The passenger's own live GPS position — a small blue dot, distinct from
  /// both bus markers and stop markers so it can't be confused with either.
  static Marker buildUserLocationMarker(LatLng position) {
    return Marker(
      point: position,
      width: 22,
      height: 22,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF38BDF8),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF38BDF8).withValues(alpha: 0.6),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
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