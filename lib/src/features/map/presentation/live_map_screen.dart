import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/bus_model.dart';
import '../models/stop_model.dart';
import '../services/bus_simulation_service.dart';
import '../widgets/bus_marker_widget.dart';
import '../widgets/stop_marker_widget.dart';
import 'bus_popup_widget.dart';

/// [busId] / [routeName] identify which simulated bus/route to show —
/// defaults to the generic demo bus when opened directly (e.g. from the
/// passenger home tab). [initialPosition] / [destinationName] come from a
/// completed reservation (see route_detail_screen.dart) so the map opens
/// centered on the passenger's pickup stop instead of the demo default.
///
/// NOTE: this screen still drives its bus marker from [BusSimulationService]
/// (a local fake, not Firestore) regardless of which bus/route is passed in
/// — the reservation flow's real-time bus data (via BusTrackingRepository)
/// isn't wired into this screen yet. Passing a real busId only affects the
/// label shown, not which bus is actually simulated.
class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({
    super.key,
    this.busId = 'BUS-001',
    this.routeName = 'Route 4A - Kampala Loop',
    this.initialPosition,
    this.destinationName,
  });

  final String busId;
  final String routeName;
  final LatLng? initialPosition;
  final String? destinationName;

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  final MapController _mapController = MapController();
  final BusSimulationService _simulationService = BusSimulationService();
  late LatLng _currentPosition =
      widget.initialPosition ?? const LatLng(0.3136, 32.5811);
  bool _isFollowingBus = true;

  static const List<LatLng> _routePoints = [
    LatLng(0.3136, 32.5811),
    LatLng(0.3180, 32.5780),
    LatLng(0.3220, 32.5760),
    LatLng(0.3292, 32.5711),
    LatLng(0.3340, 32.5675),
    LatLng(0.3300, 32.5650),
    LatLng(0.3260, 32.5680),
  ];

  static final List<StopModel> _stops = [
    StopModel(
      id: 'stop_1',
      name: 'Old Taxi Park',
      position: LatLng(0.3136, 32.5811),
    ),
    StopModel(
      id: 'stop_2',
      name: 'City Square',
      position: LatLng(0.3180, 32.5780),
    ),
    StopModel(
      id: 'stop_3',
      name: 'Wandegeya',
      position: LatLng(0.3220, 32.5760),
    ),
    StopModel(
      id: 'stop_4',
      name: 'Makerere Main Gate',
      position: LatLng(0.3292, 32.5711),
    ),
    StopModel(id: 'stop_5', name: 'CoCIS', position: LatLng(0.3340, 32.5675)),
    StopModel(
      id: 'stop_6',
      name: 'Mulago Hospital',
      position: LatLng(0.3300, 32.5650),
    ),
    StopModel(
      id: 'stop_7',
      name: 'Nakasero',
      position: LatLng(0.3260, 32.5680),
    ),
  ];

  @override
  void dispose() {
    _simulationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text(
          widget.destinationName != null
              ? 'Live Bus Tracking · to ${widget.destinationName}'
              : 'Live Bus Tracking',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: Color(0xFF2563EB)),
            onPressed: () {
              setState(() => _isFollowingBus = true);
              _mapController.move(_currentPosition, 16);
            },
          ),
        ],
      ),
      body: StreamBuilder<BusModel>(
        stream: _simulationService.simulateBusMovement(
          widget.busId,
          widget.routeName,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2563EB)),
            );
          }

          final bus = snapshot.data!;
          _currentPosition = bus.position;

          if (_isFollowingBus) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _mapController.move(bus.position, 16);
            });
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: bus.position,
                  initialZoom: 16,
                  minZoom: 12,
                  maxZoom: 18,
                  onTap: (_, __) => setState(() => _isFollowingBus = false),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                    subdomains: const ['a', 'b', 'c', 'd'],
                    userAgentPackageName: 'com.mhl.smart_ride_ug',
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        strokeWidth: 4,
                        color: const Color(0xFF2563EB),
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      // Main bus
                      Marker(
                        point: bus.position,
                        width: 50,
                        height: 50,
                        child: BusMarkerWidget(
                          bus: bus,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (context) => BusPopupWidget(bus: bus),
                            );
                          },
                          isSelected: true,
                        ),
                      ),

                      // 🔥 START MARKER - Beautiful Green Circle with Glow
                      Marker(
                        point: _routePoints.first,
                        width: 44,
                        height: 44,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF10B981,
                                ).withValues(alpha: 0.6),
                                blurRadius: 16,
                                spreadRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.circle,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),

                      // 🔥 END MARKER - Beautiful Red Flag with Glow
                      Marker(
                        point: _routePoints.last,
                        width: 44,
                        height: 44,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFEF4444,
                                ).withValues(alpha: 0.6),
                                blurRadius: 16,
                                spreadRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.flag,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: _stops.map((stop) {
                      return Marker(
                        point: stop.position,
                        width: 40,
                        height: 40,
                        child: StopMarkerWidget(
                          stop: stop,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '📍 ${stop.name}\nBuses approaching: 2\nEstimated arrival: 5 min',
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🚌 BUS-001',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${bus.speed.toStringAsFixed(0)} km/h • ${bus.passengerCount}/${bus.totalSeats} passengers',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${bus.availableSeats} seats left',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}