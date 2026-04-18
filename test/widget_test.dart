import 'package:flutter_test/flutter_test.dart';
import 'package:kinantouch_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(KinanTouchApp());

    // Verify that our app bar title is correct.
    expect(find.text('كينان تاتش'), findsOneWidget);
  });
}
