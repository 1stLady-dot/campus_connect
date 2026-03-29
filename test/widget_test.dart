import 'package:flutter_test/flutter_test.dart';
import 'package:campus_connect/main.dart';

void main() {
  testWidgets('App load smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Note: Removed 'const' because your MyApp is no longer a constant
    await tester.pumpWidget(MyApp());

    // Verify that the app starts. Since we don't have a counter, 
    // we just check if the widget exists.
    expect(find.byType(MyApp), findsOneWidget);
  });
}