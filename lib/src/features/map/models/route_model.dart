import 'package:latlong2/latlong.dart';
import 'stop_model.dart';

class RouteModel {
  final String id;
  final String name;
  final List<LatLng> polyline;
  final List<StopModel> stops;
  final String color;

  RouteModel({
    required this.id,
    required this.name,
    required this.polyline,
    required this.stops,
    this.color = '#2563EB',
  });

  factory RouteModel.fromFirestore(String docId, Map<String, dynamic> data) {
    final polylineData = data['polyline'] as List<dynamic>? ?? [];
    final stopsData = data['stops'] as List<dynamic>? ?? [];

    return RouteModel(
      id: docId,
      name: data['name'] ?? 'Unknown Route',
      polyline: polylineData.map((p) {
        return LatLng(p['lat'] as double, p['lng'] as double);
      }).toList(),
      stops: stopsData.map((s) {
        return StopModel(
          id: s['id'] ?? 'stop_${DateTime.now().millisecondsSinceEpoch}',
          name: s['name'] ?? 'Unknown Stop',
          position: LatLng(s['lat'] as double, s['lng'] as double),
        );
      }).toList(),
      color: data['color'] ?? '#2563EB',
    );
  }
}
