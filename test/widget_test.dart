import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinantouch_app/main.dart';

void main() {
  testWidgets('App basic structure test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KinanTouchApp());

    // Verify that the app exists
    expect(find.byType(KinanTouchApp), findsOneWidget);
  });
}
