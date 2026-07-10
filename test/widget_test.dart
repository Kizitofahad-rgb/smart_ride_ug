import 'package:flutter_test/flutter_test.dart';
import 'package:smart_ride_ug/main.dart';

void main() {
  testWidgets('Smart Ride UG app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartRideApp());

    // Verify that the home screen appears (look for the app title).
    expect(find.text('Smart Ride UG'), findsOneWidget);
  });
}
