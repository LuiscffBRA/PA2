import 'package:flutter_test/flutter_test.dart';
import 'package:pa2/main.dart';

void main() {
  testWidgets('App smoke test - inicializa e avança splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AchaNaRuaApp());
    expect(find.byType(AchaNaRuaApp), findsOneWidget);

    // Avança o temporizador da splash screen
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
