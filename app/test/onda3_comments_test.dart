import 'package:flutter_test/flutter_test.dart';
import 'package:pa2/features/auth/models/user_model.dart';
import 'package:pa2/features/feed/models/comment_model.dart';
import 'package:pa2/features/feed/services/feed_service.dart';

void main() {
  group('Onda 3 - Comentários em Postagens', () {
    late FeedService feedService;

    setUp(() {
      feedService = FeedService();
      feedService.reset();
    });

    test('CommentModel deve serializar e desserializar corretamente via JSON', () {
      final comment = CommentModel(
        id: 'c_test_1',
        postId: 'post_1',
        userId: 'u_123',
        userName: 'Josué Santos',
        userTradeName: null,
        content: 'O pastel é frito na hora?',
      );

      final json = comment.toJson();
      expect(json['id'], equals('c_test_1'));
      expect(json['post_id'], equals('post_1'));
      expect(json['content'], equals('O pastel é frito na hora?'));

      final fromJson = CommentModel.fromJson(json);
      expect(fromJson.id, equals('c_test_1'));
      expect(fromJson.userName, equals('Josué Santos'));
      expect(fromJson.isVendorAuthor, isFalse);
    });

    test('Deve buscar comentários existentes de um post', () async {
      final comments = await feedService.fetchComments('post_1');
      expect(comments, isNotEmpty);
      expect(comments.any((c) => c.userName == 'Josué Santos'), isTrue);
    });

    test('Deve adicionar novo comentário e incrementar a contagem no PostModel', () async {
      final initialPost = feedService.posts.firstWhere((p) => p.id == 'post_1');
      final initialCount = initialPost.commentsCount;

      final testUser = UserModel(
        id: 'u_tester',
        name: 'Marta Teste',
        email: 'marta@teste.com',
        userType: UserType.client,
      );

      final newComment = await feedService.addComment(
        postId: 'post_1',
        user: testUser,
        content: 'Que delícia! Aceita PIX?',
      );

      expect(newComment.id, isNotEmpty);
      expect(newComment.content, equals('Que delícia! Aceita PIX?'));

      final updatedPost = feedService.posts.firstWhere((p) => p.id == 'post_1');
      expect(updatedPost.commentsCount, equals(initialCount + 1));

      final updatedComments = await feedService.fetchComments('post_1');
      expect(updatedComments.any((c) => c.content == 'Que delícia! Aceita PIX?'), isTrue);
    });

    test('Deve lançar erro ao tentar adicionar comentário vazio', () async {
      final testUser = UserModel(
        id: 'u_tester',
        name: 'Marta',
        email: 'marta@teste.com',
        userType: UserType.client,
      );

      expect(
        () => feedService.addComment(
          postId: 'post_1',
          user: testUser,
          content: '   ',
        ),
        throwsException,
      );
    });
  });
}
