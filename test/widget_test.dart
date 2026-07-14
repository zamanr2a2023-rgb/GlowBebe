import 'package:flutter_test/flutter_test.dart';
import 'package:glowbebe/app.dart';

void main() {
  testWidgets('App loads Makeup Hub', (WidgetTester tester) async {
    await tester.pumpWidget(const GlowBebeApp());
    await tester.pump();

    expect(find.text('Makeup'), findsWidgets);
  });
}
