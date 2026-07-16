import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:latlong2/latlong.dart';
import 'eta_calculator_service.dart';

class MapNotificationService {
  static final MapNotificationService _instance =
      MapNotificationService._internal();
  factory MapNotificationService() => _instance;
  MapNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
    _isInitialized = true;
  }

  // Check if bus is approaching (within 300 meters)
  bool isBusApproaching(LatLng busPosition, LatLng pickupPosition) {
    final distance = ETACalculatorService.calculateETA(
      busPosition,
      pickupPosition,
    );
    return distance <= 5; // 5 minutes or less
  }

  // Send arrival notification
  Future<void> sendArrivalNotification({
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) await init();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'bus_arrival_channel',
          'Bus Arrival Alerts',
          channelDescription:
              'Notifications when your bus is approaching your pickup location',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(DateTime.now().millisecond, title, body, details);
  }

  // Send booking confirmation
  Future<void> sendBookingConfirmation(String busId, String seat) async {
    await sendArrivalNotification(
      title: '✅ Booking Confirmed!',
      body: 'Seat $seat on Bus $busId has been reserved for you.',
    );
  }

  // Send seat release notification
  Future<void> sendSeatReleaseNotification(String busId, String seat) async {
    await sendArrivalNotification(
      title: '⏰ Seat Released',
      body: 'Your reservation for seat $seat on Bus $busId has expired.',
    );
  }
}
