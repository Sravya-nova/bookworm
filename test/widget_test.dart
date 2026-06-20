import 'package:flutter_test/flutter_test.dart';
import 'package:bookworm/main.dart';

void main() {
  testWidgets('Bookworm app loads home', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BookwormAppRoot());

    // Verify that the logo text is BOOKWORM.
    expect(find.text('BOOKWORM'), findsOneWidget);
  });
}
