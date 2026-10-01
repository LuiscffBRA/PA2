import 'package:flutter_test/flutter_test.dart';
import 'package:pa2/features/feed/services/feed_service.dart';

void main() {
  group('FeedService - Curtir Postagem (Onda 2)', () {
    late FeedService feedService;
    const testUserId = 'client_123';

    setUp(() {
      feedService = FeedService();
      feedService.reset();
    });

    test('Deve curtir uma postagem e incrementar o contador de curtidas', () async {
      final post = feedService.posts.first;
      final initialLikes = post.likesCount;
      expect(post.isLikedByMe, isFalse);

      await feedService.toggleLike(post.id, testUserId);

      final updatedPost = feedService.posts.firstWhere((p) => p.id == post.id);
      expect(updatedPost.isLikedByMe, isTrue);
      expect(updatedPost.likesCount, equals(initialLikes + 1));
    });

    test('Deve descurtir uma postagem previamente curtida e decrementar o contador', () async {
      final post = feedService.posts.first;
      final initialLikes = post.likesCount;

      // Curtir
      await feedService.toggleLike(post.id, testUserId);
      var likedPost = feedService.posts.firstWhere((p) => p.id == post.id);
      expect(likedPost.isLikedByMe, isTrue);
      expect(likedPost.likesCount, equals(initialLikes + 1));

      // Descurtir
      await feedService.toggleLike(post.id, testUserId);
      var unlikedPost = feedService.posts.firstWhere((p) => p.id == post.id);
      expect(unlikedPost.isLikedByMe, isFalse);
      expect(unlikedPost.likesCount, equals(initialLikes));
    });

    test('Nao deve fazer nada ao tentar curtir um postId inexistente', () async {
      final initialCount = feedService.posts.length;
      await feedService.toggleLike('id_inexistente', testUserId);
      expect(feedService.posts.length, equals(initialCount));
    });
  });
}
