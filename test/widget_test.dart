import 'package:flutter_test/flutter_test.dart';

import 'package:smart_ride_ug/main.dart';

void main() {
  testWidgets('SmartRide home screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartRideApp());

    expect(find.text('SMART RIDE UG'), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Passenger'), findsOneWidget);
    expect(find.text('Driver'), findsOneWidget);
    expect(find.text('Admin'), findsOneWidget);
    expect(find.text('Welcome Back!'), findsOneWidget);
  });
}
