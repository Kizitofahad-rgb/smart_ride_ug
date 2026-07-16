import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class StopModel {
  final String id;
  final String name;
  final LatLng position;
  final List<String> routes;

  StopModel({
    required this.id,
    required this.name,
    required this.position,
    this.routes = const [],
  });

  factory StopModel.fromFirestore(String docId, Map<String, dynamic> data) {
    // 🔥 FIX: Import GeoPoint from cloud_firestore
    final geo = data['location'] as GeoPoint;
    return StopModel(
      id: docId,
      name: data['name'] ?? 'Unknown Stop',
      position: LatLng(geo.latitude, geo.longitude),
      routes: List<String>.from(data['routes'] ?? []),
    );
  }
}
