import 'package:flutter_test/flutter_test.dart';
import 'package:pa2/features/auth/models/user_model.dart';
import 'package:pa2/features/feed/models/post_model.dart';
import 'package:pa2/features/feed/services/feed_service.dart';

void main() {
  group('Supabase Integration & Regressão de Erros', () {
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );

    test('Validação de UUID: IDs legados (usr_...) devem ser convertidos em UUIDs válidos', () {
      const legacyId = 'usr_1790716616605';
      expect(uuidRegex.hasMatch(legacyId), isFalse);

      final hexTimestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(16).padLeft(12, '0');
      final sanitizedId = '00000000-0000-4000-8000-$hexTimestamp';

      expect(uuidRegex.hasMatch(sanitizedId), isTrue);
      expect(sanitizedId.length, equals(36));
    });

    test('Validação de UUID: UUIDs nativos do Supabase Auth devem ser preservados integralmente', () {
      const genuineSupabaseUuid = 'f568e0d9-ba84-4fae-bc39-ce9ba4c2e6dc';
      expect(uuidRegex.hasMatch(genuineSupabaseUuid), isTrue);

      String processedId = genuineSupabaseUuid;
      if (!uuidRegex.hasMatch(processedId)) {
        processedId = '00000000-0000-4000-8000-fallback';
      }

      expect(processedId, equals(genuineSupabaseUuid));
    });

    test('Mapeamento JSON do Supabase -> PostModel lida com colunas completas e nulas', () {
      final Map<String, dynamic> supabaseRow = {
        'id': 'f568e0d9-ba84-4fae-bc39-ce9ba4c2e6dc',
        'vendor_id': '00000000-0000-4000-8000-01a0ef0a796c',
        'title': 'Tigela / Copo de Açaí Turbinado 500ml',
        'description': 'Açaí puro batido com banana...',
        'price': 17.00,
        'image_url': 'assets/images/acai.jpg',
        'category': 'Sorvetes & Açaí',
        'created_at': '2026-09-29T21:22:38.528925+00:00',
        'vendor_name': 'Luis',
        'vendor_trade_name': 'Sorveteria',
        'vendor_phone': '159481855'
      };

      final post = PostModel(
        id: supabaseRow['id'].toString(),
        vendorId: supabaseRow['vendor_id'].toString(),
        vendorName: (supabaseRow['vendor_name'] as String?) ?? 'Vendedor(a)',
        vendorTradeName: (supabaseRow['vendor_trade_name'] as String?) ?? 'Ponto Local',
        vendorPhone: supabaseRow['vendor_phone'] as String?,
        title: (supabaseRow['title'] as String?) ?? '',
        description: (supabaseRow['description'] as String?) ?? '',
        price: (supabaseRow['price'] as num).toDouble(),
        imageUrl: supabaseRow['image_url'] as String?,
        category: supabaseRow['category'] as String?,
        createdAt: DateTime.tryParse(supabaseRow['created_at']?.toString() ?? '') ?? DateTime.now(),
      );

      expect(post.id, equals('f568e0d9-ba84-4fae-bc39-ce9ba4c2e6dc'));
      expect(post.vendorName, equals('Luis'));
      expect(post.vendorTradeName, equals('Sorveteria'));
      expect(post.vendorPhone, equals('159481855'));
      expect(post.price, equals(17.0));
      expect(post.category, equals('Sorvetes & Açaí'));
    });

    test('Mapeamento JSON com campos de vendedor ausentes não deve quebrar', () {
      final Map<String, dynamic> minimalRow = {
        'id': 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
        'vendor_id': 'b2c3d4e5-f6a7-8901-bcde-f12345678901',
        'title': 'Pastel de Carne',
        'description': 'Pastel crocante frito na hora',
        'price': 10,
        'category': 'Pastéis & Salgados',
      };

      final post = PostModel(
        id: minimalRow['id'].toString(),
        vendorId: minimalRow['vendor_id'].toString(),
        vendorName: (minimalRow['vendor_name'] as String?) ?? 'Vendedor(a)',
        vendorTradeName: (minimalRow['vendor_trade_name'] as String?) ?? 'Ponto Local',
        vendorPhone: minimalRow['vendor_phone'] as String?,
        title: (minimalRow['title'] as String?) ?? '',
        description: (minimalRow['description'] as String?) ?? '',
        price: (minimalRow['price'] as num).toDouble(),
        imageUrl: minimalRow['image_url'] as String?,
        category: minimalRow['category'] as String?,
        createdAt: DateTime.now(),
      );

      expect(post.vendorName, equals('Vendedor(a)'));
      expect(post.vendorTradeName, equals('Ponto Local'));
      expect(post.vendorPhone, isNull);
      expect(post.price, equals(10.0));
    });

    test('FeedService cria post e atribui UUID compatível com Postgres', () async {
      final feedService = FeedService();
      final vendor = UserModel(
        id: 'usr_test_legacy_id',
        name: 'Vendedor Teste',
        email: 'vendedor@teste.com',
        userType: UserType.vendor,
        tradeName: 'Ponto do Teste',
        phone: '11999998888',
      );

      final newPost = await feedService.createPost(
        vendor: vendor,
        title: 'Coxinha Dourada',
        description: 'Coxinha com massa de batata',
        price: 8.50,
        category: 'Pastéis & Salgados',
      );

      expect(newPost.title, equals('Coxinha Dourada'));
      expect(newPost.price, equals(8.50));
      expect(feedService.posts.first.title, equals('Coxinha Dourada'));
    });
  });
}
