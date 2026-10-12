import 'package:flutter_test/flutter_test.dart';
import 'package:egg_macha_frontend/main.dart';

void main() {
  testWidgets('Egg Macha landing screen renders', (tester) async {
    await tester.pumpWidget(const EggMachaApp());
    await tester.pumpAndSettle();
    expect(find.textContaining('EGG MACHA'), findsWidgets);
  });
}
