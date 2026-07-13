import 'package:flutter_test/flutter_test.dart';
import 'package:smart_ride_ug/main.dart';

void main() {
  testWidgets('Smart Ride UG app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartRideApp());
    expect(find.text('Smart Ride UG'), findsOneWidget);
  });
}
