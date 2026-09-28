import 'package:flutter_test/flutter_test.dart';
import 'package:pa2/main.dart';

void main() {
  testWidgets('App smoke test - inicializa na tela de cadastro', (WidgetTester tester) async {
    await tester.pumpWidget(const PegaBodeApp());

    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Cadastre-se aqui'), findsOneWidget);
  });
}
