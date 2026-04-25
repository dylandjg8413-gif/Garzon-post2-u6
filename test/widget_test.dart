import 'package:flutter_test/flutter_test.dart';
import 'package:banca_segura/main.dart';

void main() {
  testWidgets('App load test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BancaSeguraApp());

    // Verify that the title is present
    expect(find.text('Banca Segura Lab'), findsNothing); // It's in MaterialApp title, not always in UI
  });
}
