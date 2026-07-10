import 'package:flutter_test/flutter_test.dart';
import 'package:glowbebe/app.dart';

void main() {
  testWidgets('App loads login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const GlowBebeApp());
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
  });
}
