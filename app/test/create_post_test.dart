import 'package:flutter_test/flutter_test.dart';
import 'package:pa2/features/auth/models/user_model.dart';
import 'package:pa2/features/feed/services/feed_service.dart';

void main() {
  group('FeedService - Criar Postagem (Onda 1)', () {
    late FeedService feedService;

    final mockVendor = UserModel(
      id: 'vendor_123',
      name: 'Kátia da Silva',
      email: 'katia@salgados.com',
      userType: UserType.vendor,
      tradeName: 'Salgados da Kátia',
      phone: '(11) 99999-8888',
    );

    final mockClient = UserModel(
      id: 'client_123',
      name: 'Marta Oliveira',
      email: 'marta@email.com',
      userType: UserType.client,
    );

    setUp(() {
      feedService = FeedService();
      feedService.reset();
    });

    test('Deve permitir que um comerciante crie uma nova postagem com sucesso', () async {
      final initialCount = feedService.posts.length;

      final post = await feedService.createPost(
        vendor: mockVendor,
        title: 'Bolo de Pote de Chocolate',
        description: 'Delicioso bolo artesanal recheado.',
        price: 8.50,
      );

      expect(post.id, isNotEmpty);
      expect(post.title, equals('Bolo de Pote de Chocolate'));
      expect(post.price, equals(8.50));
      expect(post.vendorTradeName, equals('Salgados da Kátia'));
      expect(feedService.posts.length, equals(initialCount + 1));
      // Garante que o novo post fica no topo do feed
      expect(feedService.posts.first.title, equals('Bolo de Pote de Chocolate'));
    });

    test('Deve impedir que um Cliente crie postagem (apenas ambulantes/vendedores)', () async {
      expect(
        () => feedService.createPost(
          vendor: mockClient,
          title: 'Produto Teste',
          description: 'Desc',
          price: 10.0,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Deve validar campos obrigatórios (título, descrição, preço > 0)', () async {
      // Título vazio
      expect(
        () => feedService.createPost(
          vendor: mockVendor,
          title: '  ',
          description: 'Desc',
          price: 10.0,
        ),
        throwsA(isA<Exception>()),
      );

      // Preço inválido (<= 0)
      expect(
        () => feedService.createPost(
          vendor: mockVendor,
          title: 'Coxinha',
          description: 'Desc',
          price: 0.0,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
