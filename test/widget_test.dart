// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:pee_ka_boo/main.dart';
import 'package:pee_ka_boo/screens/login_screen.dart';
import 'package:pee_ka_boo/screens/splash_screen.dart';

void main() {
  testWidgets('App loads splash screen and navigates to login', (WidgetTester tester) async {
    await tester.pumpWidget(const PeeKaBooApp());

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
