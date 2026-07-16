import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'bloc/live_map_bloc.dart';
import 'bloc/live_map_event.dart';
import 'bloc/live_map_state.dart';
import 'data/bus_location.dart';
import 'data/bus_route.dart';
import 'data/stop.dart';
import 'route_layer_manager.dart';
import 'utils/latlng_tween.dart';

/// Passenger-facing live map. Pass [busId] to track a specific bus; defaults
/// to the single demo bus the driver screen broadcasts as, since guest
/// browsing (no reservation yet) doesn't have a specific bus assigned.
///
/// [stops] renders the tappable stop layer for this route — pass the stops
/// fetched for the reserved route so the passenger can still retarget their
/// destination from the live view. [route] draws the route polyline (falls
/// back to straight lines between [stops] if the route has no curated
/// polyline yet); pass it whenever it's available. [initialDestination]
/// pre-selects a destination (typically the passenger's nearest stop right
/// after reserving) so distance/ETA/arrival are live immediately.
class LiveMapScreen extends StatelessWidget {
  const LiveMapScreen({
    super.key,
    this.busId = 'bus-001',
    this.stops,
    this.route,
    this.initialDestination,
  });

  final String busId;
  final List<Stop>? stops;
  final BusRoute? route;
  final Stop? initialDestination;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LiveMapBloc()
        ..add(LiveMapStarted(
          busId,
          initialDestinationName: initialDestination?.name,
          initialDestinationPosition: initialDestination?.position,
        )),
      child: _LiveMapView(stops: stops ?? const [], route: route),
    );
  }
}

class _LiveMapView extends StatefulWidget {
  const _LiveMapView({required this.stops, this.route});

  final List<Stop> stops;
  final BusRoute? route;

  @override
  State<_LiveMapView> createState() => _LiveMapViewState();
}

class _LiveMapViewState extends State<_LiveMapView>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();

  static const LatLng _kampalaCenter = LatLng(0.3292, 32.5711);
  static const Duration _glideDuration = Duration(milliseconds: 900);

  double _currentZoom = 15.0;
  bool _hasCenteredOnBus = false;

  // Smoothly animate the bus marker between GPS/Firestore fixes instead of
  // snapping to each new one — updates only arrive every few seconds, so
  // without this the marker visibly jumps on every tick.
  late final AnimationController _busMotion = AnimationController(
    vsync: this,
    duration: _glideDuration,
  )..addListener(() => setState(() {}));
  late final Animation<double> _busCurve =
  CurvedAnimation(parent: _busMotion, curve: Curves.easeInOut);
  LatLngTween? _busTween;
  LatLng? _lastBusTarget;

  // Same idea for the passenger's own live position.
  late final AnimationController _userMotion = AnimationController(
    vsync: this,
    duration: _glideDuration,
  )..addListener(() => setState(() {}));
  late final Animation<double> _userCurve =
  CurvedAnimation(parent: _userMotion, curve: Curves.easeInOut);
  LatLngTween? _userTween;
  LatLng? _lastUserTarget;

  @override
  void dispose() {
    _busMotion.dispose();
    _userMotion.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _animateBusTo(LatLng target) {
    if (_lastBusTarget == target) return;
    final start = _displayedBusPosition ?? target;
    _busTween = LatLngTween(begin: start, end: target);
    _lastBusTarget = target;
    _busMotion.forward(from: 0);
  }

  void _animateUserTo(LatLng target) {
    if (_lastUserTarget == target) return;
    final start = _displayedUserPosition ?? target;
    _userTween = LatLngTween(begin: start, end: target);
    _lastUserTarget = target;
    _userMotion.forward(from: 0);
  }

  LatLng? get _displayedBusPosition =>
      _busTween?.evaluate(_busCurve) ?? _lastBusTarget;

  LatLng? get _displayedUserPosition =>
      _userTween?.evaluate(_userCurve) ?? _lastUserTarget;

  void _zoomBy(double delta) {
    _currentZoom = (_currentZoom + delta).clamp(12.0, 18.0);
    _mapController.move(_mapController.camera.center, _currentZoom);
  }

  void _onStopTap(Stop stop) {
    context.read<LiveMapBloc>().add(
      LiveMapDestinationSelected(stop.name, stop.position),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Destination set: ${stop.name}')),
    );
  }

  void _showBusDetails(BusLocation bus, LiveMapState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.directions_bus, color: Color(0xFF60A5FA)),
                  const SizedBox(width: 8),
                  Text(
                    bus.busId,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  _StatusChip(status: bus.status, isStale: bus.isStale),
                ],
              ),
              const SizedBox(height: 16),
              _DetailRow(label: 'Speed', value: '${bus.speedKmh.toStringAsFixed(0)} km/h'),
              if (state.distanceMeters != null)
                _DetailRow(
                  label: 'Distance to destination',
                  value: _formatDistance(state.distanceMeters!),
                ),
              if (state.eta != null)
                _DetailRow(label: 'ETA', value: _formatDuration(state.eta!)),
              if (bus.lastUpdated != null)
                _DetailRow(
                  label: 'Last update',
                  value: _formatRelativeTime(bus.lastUpdated!),
                ),
            ],
          ),
        );
      },
    );
  }

  static String _formatDistance(double meters) {
    if (meters < 1000) return '${meters.toStringAsFixed(0)} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  static String _formatDuration(Duration d) {
    if (d.inMinutes < 1) return '<1 min';
    if (d.inMinutes < 60) return '${d.inMinutes} min';
    final hours = d.inMinutes ~/ 60;
    final mins = d.inMinutes % 60;
    return '${hours}h ${mins}m';
  }

  static String _formatRelativeTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: BlocConsumer<LiveMapBloc, LiveMapState>(
        listener: (context, state) {
          if (state.busLocation != null) {
            _animateBusTo(state.busLocation!.position);
          }
          if (state.userPosition != null) {
            _animateUserTo(state.userPosition!);
          }

          // Auto-center the camera on the bus the first time it appears.
          if (!_hasCenteredOnBus && state.busLocation != null) {
            _hasCenteredOnBus = true;
            _mapController.move(state.busLocation!.position, _currentZoom);
          }
          if (state.hasArrived) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFFF59E0B),
                content: Text('Bus has arrived at ${state.destinationName}'),
              ),
            );
          }
        },
        builder: (context, state) {
          final busPosition = _displayedBusPosition ?? state.busLocation?.position;
          final userPosition = _displayedUserPosition ?? state.userPosition;
          final route = widget.route;

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: busPosition ?? _kampalaCenter,
                  initialZoom: _currentZoom,
                  minZoom: 12.0,
                  maxZoom: 18.0,
                ),
                children: [
                  // CartoDB Dark Matter tiles — free, no API key, matches
                  // the app's dark theme. Swap the urlTemplate below for
                  // 'light_all' if you ever want the light basemap back.
                  TileLayer(
                    urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                    subdomains: const ['a', 'b', 'c', 'd'],
                    userAgentPackageName: 'com.mhl.smart_ride_ug',
                    maxZoom: 20,
                  ),
                  if (route != null &&
                      (route.polyline.length > 1 || widget.stops.length > 1))
                    PolylineLayer(
                      polylines: [
                        RouteLayerManager.buildRoutePolyline(
                          route,
                          fallbackStops: widget.stops,
                        ),
                      ],
                    ),
                  if (widget.stops.isNotEmpty)
                    RouteLayerManager.buildStopMarkerLayer(
                      stops: widget.stops,
                      onStopTap: _onStopTap,
                    ),
                  MarkerLayer(
                    markers: [
                      if (busPosition != null)
                        RouteLayerManager.buildBusMarker(
                          busPosition,
                          status: state.busLocation!.status,
                          hasArrived: state.hasArrived,
                          onTap: () => _showBusDetails(state.busLocation!, state),
                        ),
                      if (userPosition != null)
                        RouteLayerManager.buildUserLocationMarker(userPosition),
                      if (state.destination != null)
                        RouteLayerManager.buildDestinationMarker(
                          state.destination!,
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
              ),
              if (state.isLoading)
                const _TopBanner(
                  icon: Icons.hourglass_top,
                  color: Color(0xFF1E293B),
                  text: 'Connecting to live tracking…',
                )
              else if (state.busLocation == null)
                const _TopBanner(
                  icon: Icons.wifi_tethering_off,
                  color: Color(0xFF1E293B),
                  text: 'Waiting for the driver to start the trip…',
                )
              else if (state.destinationName != null)
                  _TopBanner(
                    icon: state.hasArrived
                        ? Icons.check_circle
                        : Icons.location_on,
                    color: state.hasArrived
                        ? const Color(0xFF166534)
                        : const Color(0xFF1E293B),
                    text: state.hasArrived
                        ? 'Arrived at ${state.destinationName}'
                        : 'To: ${state.destinationName}'
                        '${state.distanceMeters != null ? '  •  ${_formatDistance(state.distanceMeters!)}' : ''}'
                        '${state.eta != null ? '  •  ETA ${_formatDuration(state.eta!)}' : ''}',
                    onClose: () => context
                        .read<LiveMapBloc>()
                        .add(const LiveMapDestinationCleared()),
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
          );
        },
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
              color: Colors.black.withValues(alpha: 0.4),
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

class _TopBanner extends StatelessWidget {
  const _TopBanner({
    required this.icon,
    required this.color,
    required this.text,
    this.onClose,
  });

  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (onClose != null)
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8))),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.isStale});

  final BusTrackingStatus status;
  final bool isStale;

  @override
  Widget build(BuildContext context) {
    final label = isStale ? 'Stale' : status.name;
    final color = isStale
        ? const Color(0xFF64748B)
        : status == BusTrackingStatus.active
        ? const Color(0xFF10B981)
        : const Color(0xFFF59E0B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}