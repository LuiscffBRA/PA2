import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pa2/core/theme/app_theme.dart';
import 'package:pa2/features/auth/screens/register_screen.dart';

void main() {
  testWidgets('RegisterScreen renderiza campos básicos e alterna para Vendedor', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const RegisterScreen(),
      ),
    );

    // Verifica elementos do cabeçalho
    expect(find.text('Criar Conta'), findsOneWidget);
    expect(find.text('Cadastre-se no Pega Bode'), findsOneWidget);
    expect(find.text('Sou Cliente'), findsOneWidget);
    expect(find.text('Sou Vendedor'), findsOneWidget);

    // Inicialmente como Cliente: não exibe campo de ponto de venda
    expect(find.text('Nome do Ponto / Barraca'), findsNothing);

    // Toca no botão "Sou Vendedor"
    await tester.tap(find.text('Sou Vendedor'));
    await tester.pumpAndSettle();

    // Agora deve exibir os campos específicos de vendedor
    expect(find.text('Nome do Ponto / Barraca'), findsOneWidget);
    expect(find.text('Telefone / WhatsApp'), findsOneWidget);
  });
}
