import 'package:flutter_test/flutter_test.dart';
import 'package:babymama/main.dart';

void main() {
  testWidgets('App launches without error', (WidgetTester tester) async {
    await tester.pumpWidget(const BabyMamaApp());
    expect(find.text('babymama'), findsOneWidget);
  });
}
