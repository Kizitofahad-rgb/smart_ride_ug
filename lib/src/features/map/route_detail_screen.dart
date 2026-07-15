import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../core/services/auth_service.dart';
import 'data/bus_location.dart';
import 'data/bus_route.dart';
import 'data/bus_tracking_repository.dart';
import 'data/reservation_service.dart';
import 'data/routes_repository.dart';
import 'data/stop.dart';
import 'live_map_screen.dart';
import 'route_layer_manager.dart';

/// Step 3 of "Find My Bus": the route on the map with every stop along it,
/// the passenger's own location plotted against the nearest stop, and
/// whichever buses are currently live on the route. "Reserve" books a seat
/// (via [ReservationService]) at the nearest stop, then opens live tracking.
class RouteDetailScreen extends StatefulWidget {
  const RouteDetailScreen({
    super.key,
    required this.route,
    required this.destination,
  });

  final BusRoute route;
  final Stop destination;

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  final RoutesRepository _routesRepository = RoutesRepository();
  final BusTrackingRepository _busRepository = BusTrackingRepository();
  final ReservationService _reservationService = ReservationService();
  final MapController _mapController = MapController();

  List<Stop>? _stops;
  Position? _userPosition;
  String? _loadError;
  bool _isReserving = false;

  @override
  void initState() {
    super.initState();
    _loadStops();
    _loadUserPosition();
  }

  Future<void> _loadStops() async {
    try {
      final stops = await _routesRepository.fetchStopsForRoute(widget.route);
      if (mounted) setState(() => _stops = stops);
    } catch (e) {
      if (mounted) setState(() => _loadError = 'Could not load stops: $e');
    }
  }

  Future<void> _loadUserPosition() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return; // Nearest-stop panel just won't show; map still works.
      }
      final position = await Geolocator.getCurrentPosition();
      if (mounted) setState(() => _userPosition = position);
    } catch (_) {
      // Best-effort — location services off, emulator with no fix, etc.
    }
  }

  /// The stop on this route closest to the passenger right now, or null
  /// until both the stop list and the device's GPS fix are ready.
  Stop? get _nearestStop {
    final stops = _stops;
    final user = _userPosition;
    if (stops == null || stops.isEmpty || user == null) return null;

    final userLatLng = LatLng(user.latitude, user.longitude);
    return stops.reduce((a, b) {
      final da = GeoUtils.distanceMeters(userLatLng, a.position);
      final db = GeoUtils.distanceMeters(userLatLng, b.position);
      return da <= db ? a : b;
    });
  }

  double? get _nearestStopDistanceMeters {
    final stop = _nearestStop;
    final user = _userPosition;
    if (stop == null || user == null) return null;
    return GeoUtils.distanceMeters(
      LatLng(user.latitude, user.longitude),
      stop.position,
    );
  }

  Future<void> _reserve(List<BusLocation> activeBuses) async {
    final nearestStop = _nearestStop;
    if (nearestStop == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "We can't find your location yet — enable location and try again.",
          ),
        ),
      );
      return;
    }

    if (!AuthService.instance.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to reserve a seat.')),
      );
      context.push('/passenger-login');
      return;
    }

    setState(() => _isReserving = true);
    try {
      // If a bus is already live on this route, tie the reservation to the
      // closest one; otherwise the passenger reserves ahead of any bus
      // starting its trip, and live tracking begins once one does.
      BusLocation? assignedBus;
      if (activeBuses.isNotEmpty) {
        assignedBus = activeBuses.reduce((a, b) {
          final da = GeoUtils.distanceMeters(a.position, nearestStop.position);
          final db = GeoUtils.distanceMeters(b.position, nearestStop.position);
          return da <= db ? a : b;
        });
      }

      await _reservationService.createReservation(
        // AuthService only tracks a display name today, not a real uid —
        // swap this for the actual auth uid once that lands.
        userId: AuthService.instance.userName ?? 'guest',
        routeId: widget.route.id,
        routeName: widget.route.name,
        pickupStopId: nearestStop.id,
        pickupStopName: nearestStop.name,
        destinationStopId: widget.destination.id,
        destinationStopName: widget.destination.name,
        busId: assignedBus?.busId,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reserved! Pickup at ${nearestStop.name}.')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LiveMapScreen(
            busId: assignedBus?.busId ?? 'bus-001',
            stops: _stops,
            initialDestination: nearestStop,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not reserve: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isReserving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        title: Text(widget.route.name),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<BusLocation>>(
        stream: _busRepository.watchBusesForRoute(widget.route.id),
        builder: (context, busSnapshot) {
          final activeBuses = busSnapshot.data ?? const <BusLocation>[];
          return Column(
            children: [
              Expanded(child: _buildMap(activeBuses)),
              _buildBottomPanel(activeBuses),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMap(List<BusLocation> activeBuses) {
    if (_loadError != null) {
      return Center(
        child: Text(_loadError!, style: const TextStyle(color: Color(0xFFF59E0B))),
      );
    }
    final stops = _stops;
    if (stops == null) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF2563EB)),
      );
    }

    final polyline = widget.route.polyline.isNotEmpty
        ? widget.route.polyline
        : stops.map((s) => s.position).toList();

    final center = stops.isNotEmpty
        ? stops[stops.length ~/ 2].position
        : const LatLng(0.3292, 32.5711);

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: 14.5,
        minZoom: 11.0,
        maxZoom: 18.0,
      ),
      children: [
        TileLayer(
          urlTemplate:
          'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
          subdomains: const ['a', 'b', 'c', 'd'],
          userAgentPackageName: 'com.mhl.smart_ride_ug',
          maxZoom: 20,
        ),
        if (polyline.length > 1)
          PolylineLayer(
            polylines: [
              Polyline(
                points: polyline,
                strokeWidth: 4,
                color: Color(widget.route.colorValue),
              ),
            ],
          ),
        RouteLayerManager.buildStopMarkerLayer(
          stops: stops,
          highlightedStopId: _nearestStop?.id,
        ),
        MarkerLayer(
          markers: [
            for (final bus in activeBuses)
              RouteLayerManager.buildBusMarker(
                bus.position,
                status: bus.status,
                hasArrived: false,
              ),
            if (_userPosition != null)
              RouteLayerManager.buildUserLocationMarker(
                LatLng(_userPosition!.latitude, _userPosition!.longitude),
              ),
          ],
        ),
        const RichAttributionWidget(
          attributions: [
            TextSourceAttribution('OpenStreetMap contributors'),
            TextSourceAttribution('CARTO'),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomPanel(List<BusLocation> activeBuses) {
    final nearestStop = _nearestStop;
    final nearestDistance = _nearestStopDistanceMeters;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.near_me, color: Color(0xFF60A5FA), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  nearestStop == null
                      ? 'Finding your nearest stop…'
                      : 'Nearest stop: ${nearestStop.name}'
                      '${nearestDistance != null ? ' · ${_formatDistance(nearestDistance)} away' : ''}',
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            activeBuses.isEmpty
                ? 'No buses are broadcasting on this route right now.'
                : '${activeBuses.length} bus${activeBuses.length == 1 ? '' : 'es'} live on this route.',
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _isReserving ? null : () => _reserve(activeBuses),
            child: _isReserving
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : const Text('Reserve a seat',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  static String _formatDistance(double meters) {
    if (meters < 1000) return '${meters.toStringAsFixed(0)} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
}