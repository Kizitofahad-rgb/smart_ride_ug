import 'package:geolocator/geolocator.dart';

/// Single choke point for reading the device's own GPS position. Wraps
/// Geolocator so every caller (passenger's LiveMapBloc, route detail's
/// nearest-stop calc, driver broadcast) shares one permission-request path
/// instead of duplicating the boilerplate.
class LocationService {
  LocationService._();

  static final LocationService instance = LocationService._();

  /// Makes sure location services are on and permission is granted.
  /// Never throws — returns false when the passenger has denied access so
  /// callers can degrade gracefully (map still works, just no live dot).
  Future<bool> ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// One-off fix, e.g. for "nearest stop" calculations. Returns null on any
  /// failure (permission denied, services off, no fix available) rather
  /// than throwing, since a missing location should never crash the map.
  Future<Position?> getCurrentPosition() async {
    final granted = await ensurePermission();
    if (!granted) return null;
    try {
      return await Geolocator.getCurrentPosition();
    } catch (_) {
      return null;
    }
  }

  /// Live stream of the device's position for continuous tracking on the
  /// live map. [distanceFilterMeters] stops it from firing on GPS jitter
  /// while the passenger is standing still.
  Stream<Position> watchPosition({int distanceFilterMeters = 5}) {
    final settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: distanceFilterMeters,
    );
    return Geolocator.getPositionStream(locationSettings: settings);
  }
}