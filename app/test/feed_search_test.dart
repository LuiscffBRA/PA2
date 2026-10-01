import 'package:flutter_test/flutter_test.dart';
import 'package:pa2/features/feed/services/feed_service.dart';

void main() {
  group('FeedService - Pesquisar Perfil / Venda (Onda 2)', () {
    late FeedService feedService;

    setUp(() {
      feedService = FeedService();
      feedService.reset();
    });

    test('Deve retornar postagens que contenham o termo no titulo', () {
      final results = feedService.searchPosts('Bolo');
      expect(results.isNotEmpty, isTrue);
      expect(results.every((p) => p.title.toLowerCase().contains('bolo')), isTrue);
    });

    test('Deve retornar postagens que contenham o termo no nome do vendedor (tradeName)', () {
      final results = feedService.searchPosts('Clara');
      expect(results.isNotEmpty, isTrue);
      expect(results.every((p) => p.vendorTradeName.toLowerCase().contains('clara')), isTrue);
    });

    test('Deve ser case-insensitive (ignorar maiusculas e minusculas)', () {
      final results1 = feedService.searchPosts('BOLO');
      final results2 = feedService.searchPosts('bolo');
      expect(results1.length, equals(results2.length));
    });

    test('Deve retornar vazio se o termo nao existir em nenhuma postagem', () {
      final results = feedService.searchPosts('TERMO_INEXISTENTE_123');
      expect(results.isEmpty, isTrue);
    });
  });
}
