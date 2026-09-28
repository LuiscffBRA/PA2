import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pa2/features/feed/models/post_model.dart';
import 'package:pa2/features/feed/widgets/post_card_widget.dart';
import 'package:pa2/features/feed/widgets/post_details_modal.dart';

void main() {
  group('Feed - Rolar / Visualizar Feed (Onda 1)', () {
    final samplePost = PostModel(
      id: 'post_test',
      vendorId: 'vendor_1',
      vendorName: 'Seu Zé',
      vendorTradeName: 'Pastelaria do Zé',
      vendorPhone: '(11) 98765-4321',
      title: 'Pastel Especial de Carne',
      description: 'Crocante e quentinho, feito na hora.',
      price: 10.50,
      category: 'Pastéis & Salgados',
      imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=700&q=80',
    );

    testWidgets('PostCardWidget renderiza dados essenciais do produto', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCardWidget(post: samplePost),
          ),
        ),
      );

      // Nome do vendedor / ponto
      expect(find.text('Pastelaria do Zé'), findsOneWidget);
      expect(find.text('Por Seu Zé'), findsOneWidget);

      // Preço e título
      expect(find.text('R\$ 10.50'), findsOneWidget);
      expect(find.text('Pastel Especial de Carne'), findsOneWidget);
      expect(find.text('Pastéis & Salgados'), findsOneWidget);
    });

    testWidgets('Tocar no card abre modal de detalhes do produto', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCardWidget(post: samplePost),
          ),
        ),
      );

      // Toca no card
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Modal de detalhes aberto
      expect(find.byType(PostDetailsModal), findsOneWidget);
      expect(find.text('Informações do Ponto de Venda'), findsOneWidget);
      expect(find.text('Fechar Detalhes'), findsOneWidget);
    });
  });
}
