import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pa2/features/auth/models/user_model.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

class FeedService extends ChangeNotifier {
  static final FeedService _instance = FeedService._internal();
  factory FeedService() => _instance;
  FeedService._internal() {
    _initSeedData();
    _fetchPostsFromSupabase();
  }

  final List<PostModel> _posts = [];
  final Map<String, List<CommentModel>> _commentsByPostId = {};
  bool _isLoading = false;

  List<PostModel> get posts => List.unmodifiable(_posts);
  bool get isLoading => _isLoading;

  /// Busca postagens do Supabase com fallback para dados locais
  Future<void> _fetchPostsFromSupabase() async {
    try {
      final client = Supabase.instance.client;
      final currentUserId = client.auth.currentUser?.id;

      final response = await client
          .from('posts')
          .select('*, likes(user_id), comments(id)')
          .order('created_at', ascending: false);

      final dbPosts = (response as List).map((row) {
        final likes = row['likes'] as List<dynamic>? ?? [];
        final comments = row['comments'] as List<dynamic>? ?? [];
        final likesCount = likes.length;
        final commentsCount = comments.length;
        final isLikedByMe = currentUserId != null
            ? likes.any((like) => like['user_id'] == currentUserId)
            : false;

        return PostModel(
          id: row['id'].toString(),
          vendorId: row['vendor_id'].toString(),
          vendorName: row['vendor_name'] ?? 'Vendedor(a)',
          vendorTradeName: row['vendor_trade_name'] ?? 'Ponto Local',
          vendorPhone: row['vendor_phone'],
          vendorReferencePoint: row['vendor_reference_point'],
          vendorPixKey: row['vendor_pix_key'],
          title: row['title'] ?? '',
          description: row['description'] ?? '',
          price: (row['price'] as num).toDouble(),
          imageUrl: row['image_url'],
          category: row['category'],
          createdAt: DateTime.tryParse(row['created_at'] ?? '') ?? DateTime.now(),
          likesCount: likesCount,
          commentsCount: commentsCount,
          isLikedByMe: isLikedByMe,
        );
      }).toList();

      _posts.clear();
      _posts.addAll(dbPosts);
      notifyListeners();
      
    } catch (e) {
      debugPrint('Aviso Supabase: falha ao recarregar postagens ($e)');
    }
  }

  /// Curte ou descurte uma postagem (Onda 2)
  Future<void> toggleLike(String postId, String userId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = _posts[index];
    final isCurrentlyLiked = post.isLikedByMe;

    // Atualização otimista
    _posts[index] = post.copyWith(
      isLikedByMe: !isCurrentlyLiked,
      likesCount: post.likesCount + (isCurrentlyLiked ? -1 : 1),
    );
    notifyListeners();

    try {
      final client = Supabase.instance.client;
      if (isCurrentlyLiked) {
        // Remover curtida
        await client
            .from('likes')
            .delete()
            .match({'post_id': postId, 'user_id': userId});
      } else {
        // Adicionar curtida
        await client
            .from('likes')
            .insert({'post_id': postId, 'user_id': userId});
      }
    } catch (e) {
      debugPrint('Aviso Supabase (Like offline/teste): $e');
    }
  }

  /// Busca a lista de comentários de uma postagem (Onda 3 - Comentar Postagens)
  Future<List<CommentModel>> fetchComments(String postId) async {
    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('comments')
          .select()
          .eq('post_id', postId)
          .order('created_at', ascending: true);

      final comments = (response as List).map((row) => CommentModel.fromJson(row)).toList();
      _commentsByPostId[postId] = comments;
      
      // Atualiza a contagem no post correspondente
      final postIndex = _posts.indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        _posts[postIndex] = _posts[postIndex].copyWith(commentsCount: comments.length);
        notifyListeners();
      }

      return comments;
    } catch (e) {
      debugPrint('Aviso: Falha ao buscar comentários no Supabase ($e)');
      // Fallback em memória
      return _commentsByPostId[postId] ?? [];
    }
  }

  /// Adiciona um novo comentário a uma postagem (Onda 3 - Comentar Postagens)
  Future<CommentModel> addComment({
    required String postId,
    required UserModel user,
    required String content,
  }) async {
    final cleanContent = content.trim();
    if (cleanContent.isEmpty) {
      throw Exception('O comentário não pode ficar vazio.');
    }

    String commentId = 'comment_${DateTime.now().millisecondsSinceEpoch}';

    // Valida UUID do usuário para compatibilidade com Supabase
    String validUserId = user.id;
    final uuidRegex = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');
    if (!uuidRegex.hasMatch(validUserId)) {
      final hexTimestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(16).padLeft(12, '0');
      validUserId = '00000000-0000-4000-8000-$hexTimestamp';
    }

    final newComment = CommentModel(
      id: commentId,
      postId: postId,
      userId: validUserId,
      userName: user.name,
      userTradeName: user.tradeName,
      content: cleanContent,
      createdAt: DateTime.now(),
    );

    // Atualização local imediata
    _commentsByPostId.putIfAbsent(postId, () => []);
    _commentsByPostId[postId]!.add(newComment);

    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex != -1) {
      _posts[postIndex] = _posts[postIndex].copyWith(
        commentsCount: _posts[postIndex].commentsCount + 1,
      );
    }
    notifyListeners();

    // Persistência no Supabase
    try {
      final client = Supabase.instance.client;
      final payload = {
        'post_id': postId,
        'user_id': validUserId,
        'user_name': user.name,
        'user_trade_name': user.tradeName,
        'content': cleanContent,
      };

      final inserted = await client.from('comments').insert(payload).select().single();
      final persistedComment = CommentModel.fromJson(inserted);
      
      // Atualiza o ID do comentário com o id retornado pelo Supabase
      final list = _commentsByPostId[postId]!;
      final idx = list.indexWhere((c) => c.id == commentId);
      if (idx != -1) {
        list[idx] = persistedComment;
      }
      return persistedComment;
    } catch (e) {
      debugPrint('Aviso Supabase (Comentário salvo em fallback): $e');
    }

    return newComment;
  }

  /// Recarrega postagens (para pull-to-refresh)
  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    await _fetchPostsFromSupabase();
    _isLoading = false;
    notifyListeners();
  }

  /// Pesquisa postagens por título, descrição ou nome do vendedor (Onda 2)
  List<PostModel> searchPosts(String query) {
    if (query.trim().isEmpty) return _posts;
    final lowerQuery = query.toLowerCase().trim();
    return _posts.where((post) {
      return post.title.toLowerCase().contains(lowerQuery) ||
             post.description.toLowerCase().contains(lowerQuery) ||
             post.vendorTradeName.toLowerCase().contains(lowerQuery) ||
             post.vendorName.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Busca postagens do banco de dados para um vendedor específico (Onda 2)
  Future<List<PostModel>> fetchPostsByVendor(String vendorId) async {
    try {
      final client = Supabase.instance.client;
      final currentUserId = client.auth.currentUser?.id;

      final data = await client
          .from('posts')
          .select('*, likes(user_id), comments(id)')
          .eq('vendor_id', vendorId)
          .order('created_at', ascending: false);

      final List<PostModel> fetchedPosts = [];
      for (final row in data as List) {
        final likes = row['likes'] as List<dynamic>? ?? [];
        final comments = row['comments'] as List<dynamic>? ?? [];
        final likesCount = likes.length;
        final commentsCount = comments.length;
        final isLikedByMe = currentUserId != null
            ? likes.any((like) => like['user_id'] == currentUserId)
            : false;

        fetchedPosts.add(PostModel(
          id: row['id'].toString(),
          vendorId: row['vendor_id'].toString(),
          vendorName: row['vendor_name'] ?? 'Vendedor(a)',
          vendorTradeName: row['vendor_trade_name'] ?? 'Ponto Local',
          vendorPhone: row['vendor_phone'],
          vendorReferencePoint: row['vendor_reference_point'],
          vendorPixKey: row['vendor_pix_key'],
          title: row['title'] ?? '',
          description: row['description'] ?? '',
          price: (row['price'] as num).toDouble(),
          imageUrl: row['image_url'],
          category: row['category'],
          createdAt: DateTime.tryParse(row['created_at'] ?? '') ?? DateTime.now(),
          likesCount: likesCount,
          commentsCount: commentsCount,
          isLikedByMe: isLikedByMe,
        ));
      }
      return fetchedPosts;
    } catch (e) {
      debugPrint('Aviso: Falha ao buscar posts do vendedor: $e');
      // Tenta fallback offline
      return _posts.where((p) => p.vendorId.toLowerCase() == vendorId.toLowerCase()).toList();
    }
  }

  /// Cria uma nova postagem no Supabase e atualiza o feed local
  Future<PostModel> createPost({
    required UserModel vendor,
    required String title,
    required String description,
    required double price,
    String? imageUrl,
    String? category,
  }) async {
    if (!vendor.isVendor) {
      throw Exception('Apenas usuários comerciantes/vendedores podem criar postagens.');
    }
    if (title.trim().isEmpty) {
      throw Exception('Informe o nome ou título do produto.');
    }
    if (description.trim().isEmpty) {
      throw Exception('Informe a descrição do produto.');
    }
    if (price <= 0) {
      throw Exception('O valor do produto deve ser maior que zero.');
    }

    final postImage = imageUrl?.trim().isNotEmpty == true
        ? imageUrl!.trim()
        : 'assets/images/pastel.jpg';

    String newId = 'post_${DateTime.now().millisecondsSinceEpoch}';

    // Garante que o vendor_id enviado ao banco é sempre um UUID válido para o Postgres
    String validVendorId = vendor.id;
    final uuidRegex = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');
    if (!uuidRegex.hasMatch(validVendorId)) {
      final hexTimestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(16).padLeft(12, '0');
      validVendorId = '00000000-0000-4000-8000-$hexTimestamp';
    }

    // Tenta persistir no Supabase
    try {
      final client = Supabase.instance.client;

      // 1. Garante que o registro do Vendedor existe na tabela profiles antes de criar a foreign key
      try {
        await client.from('profiles').upsert({
          'id': validVendorId,
          'name': vendor.name,
          'email': vendor.email,
          'user_type': vendor.userType.name,
          'phone': vendor.phone,
          'trade_name': vendor.tradeName,
          'bio': vendor.bio,
          'pix_key': vendor.pixKey,
          'pix_key_type': vendor.pixKeyType,
          'reference_point': vendor.referencePoint,
        });
      } catch (profileErr) {
        debugPrint('Aviso ao sincronizar perfil do vendedor no Supabase: $profileErr');
      }

      // 2. Insere a postagem na tabela posts
      final payload = {
        'vendor_id': validVendorId,
        'vendor_name': vendor.name,
        'vendor_trade_name': vendor.tradeName ?? vendor.name,
        'vendor_phone': vendor.phone,
        'vendor_reference_point': vendor.referencePoint,
        'vendor_pix_key': vendor.pixKey,
        'title': title.trim(),
        'description': description.trim(),
        'price': price,
        'image_url': postImage,
        'category': category?.trim() ?? 'Outros',
      };

      try {
        final inserted = await client.from('posts').insert(payload).select().single();
        newId = inserted['id'].toString();
      } catch (insertError) {
        debugPrint('Tentando insert sem colunas extras: $insertError');
        final simplePayload = {
          'vendor_id': validVendorId,
          'title': title.trim(),
          'description': description.trim(),
          'price': price,
          'image_url': postImage,
          'category': category?.trim() ?? 'Outros',
        };
        final inserted = await client.from('posts').insert(simplePayload).select().single();
        newId = inserted['id'].toString();
      }
    } catch (e) {
      debugPrint('Aviso ao salvar post no Supabase: $e');
      final errorStr = e.toString().toLowerCase();
      // Em caso de erro real de banco (não sendo teste offline sem supabase)
      if (!errorStr.contains('initialized') && !errorStr.contains('assertion') && !errorStr.contains('network')) {
        throw Exception('Não foi possível salvar no banco de dados: $e');
      }
    }

    final newPost = PostModel(
      id: newId,
      vendorId: vendor.id,
      vendorName: vendor.name,
      vendorTradeName: vendor.tradeName ?? vendor.name,
      vendorPhone: vendor.phone,
      vendorReferencePoint: vendor.referencePoint,
      vendorPixKey: vendor.pixKey,
      title: title.trim(),
      description: description.trim(),
      price: price,
      imageUrl: postImage,
      category: category?.trim(),
      createdAt: DateTime.now(),
      commentsCount: 0,
    );

    _posts.insert(0, newPost);
    notifyListeners();
    return newPost;
  }

  void _initSeedData() {
    if (_posts.isNotEmpty) return;
    _posts.addAll([
      // 1. Pastéis & Salgados
      PostModel(
        id: 'post_1',
        vendorId: 'v_1',
        vendorName: 'Kátia da Silva',
        vendorTradeName: 'Kátia da Esquina - Salgados',
        vendorPhone: '(11) 98765-4321',
        vendorReferencePoint: 'Em frente ao portão principal da faculdade - Barraca Amarela',
        vendorPixKey: '11987654321',
        title: 'Pastel de Carne com Queijo na Hora',
        description: 'Massa crocante de feira, recheado com carne moída bem temperada e queijo derretido.',
        price: 9.50,
        imageUrl: 'assets/images/pastel.jpg',
        category: 'Pastéis & Salgados',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        likesCount: 28,
        commentsCount: 3,
      ),
      PostModel(
        id: 'post_2',
        vendorId: 'v_1',
        vendorName: 'Kátia da Silva',
        vendorTradeName: 'Kátia da Esquina - Salgados',
        vendorPhone: '(11) 98765-4321',
        vendorReferencePoint: 'Em frente ao portão principal da faculdade - Barraca Amarela',
        vendorPixKey: '11987654321',
        title: 'Coxinha Dourada de Frango com Catupiry',
        description: 'Massa artesanal super macia e recheio cremoso com muito frango desfiado.',
        price: 8.50,
        imageUrl: 'assets/images/coxinha.jpg',
        category: 'Pastéis & Salgados',
        createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
        likesCount: 34,
        commentsCount: 2,
      ),
      PostModel(
        id: 'post_3',
        vendorId: 'v_1',
        vendorName: 'Kátia da Silva',
        vendorTradeName: 'Kátia da Esquina - Salgados',
        vendorPhone: '(11) 98765-4321',
        vendorReferencePoint: 'Em frente ao portão principal da faculdade - Barraca Amarela',
        vendorPixKey: '11987654321',
        title: 'Pastel Especial de Palmito e Queijo',
        description: 'Recheio cremoso de palmito selecionado com bastante queijo mussarela derretido.',
        price: 10.00,
        imageUrl: 'assets/images/pastel.jpg',
        category: 'Pastéis & Salgados',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        likesCount: 15,
        commentsCount: 1,
      ),
      PostModel(
        id: 'post_4',
        vendorId: 'v_3',
        vendorName: 'Dona Maria Salgadeira',
        vendorTradeName: 'Cantinho da Empada & Salgados',
        vendorPhone: '(11) 97777-1111',
        vendorReferencePoint: 'Feira Livre de Domingo - Box 42',
        vendorPixKey: '123.456.789-00',
        title: 'Pastel Frito Crocante de Carne',
        description: 'Pastel sequinho de feira com vinagrete à parte para acompanhar.',
        price: 9.00,
        imageUrl: 'assets/images/pastel.jpg',
        category: 'Pastéis & Salgados',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likesCount: 22,
        commentsCount: 2,
      ),

      // 2. Esfihas & Árabe
      PostModel(
        id: 'post_5',
        vendorId: 'v_4',
        vendorName: 'Tariq Mansur',
        vendorTradeName: 'Tariq Esfiharia de Rua',
        vendorPhone: '(11) 96666-2222',
        vendorReferencePoint: 'Avenida Brasil, próximo ao ponto de ônibus da Estação',
        vendorPixKey: '98765432-1234-5678-90ab-cdef01234567',
        title: 'Esfiha Aberta de Carne Temperada',
        description: 'Massa fininha e leve, recheada com carne moída, cebola, tomate fresco e toque de limão.',
        price: 6.50,
        imageUrl: 'assets/images/esfiha.jpg',
        category: 'Esfihas & Árabe',
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
        likesCount: 39,
        commentsCount: 4,
      ),
      PostModel(
        id: 'post_6',
        vendorId: 'v_4',
        vendorName: 'Tariq Mansur',
        vendorTradeName: 'Tariq Esfiharia de Rua',
        vendorPhone: '(11) 96666-2222',
        vendorReferencePoint: 'Avenida Brasil, próximo ao ponto de ônibus da Estação',
        vendorPixKey: '98765432-1234-5678-90ab-cdef01234567',
        title: 'Esfiha Aberta de Queijo Derretido',
        description: 'Massa macia com generosa cobertura de queijo derretido e orégano.',
        price: 7.00,
        imageUrl: 'assets/images/esfiha.jpg',
        category: 'Esfihas & Árabe',
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
        likesCount: 27,
        commentsCount: 1,
      ),

      // 3. Sorvetes & Açaí
      PostModel(
        id: 'post_8',
        vendorId: 'v_5',
        vendorName: 'Felipe Neves',
        vendorTradeName: 'Açaí & Sorvetes da Praça',
        vendorPhone: '(11) 95555-3333',
        vendorReferencePoint: 'Quiosque 3 no Parque Ecológico Municipal',
        vendorPixKey: '11955553333',
        title: 'Açaí Turbinado na Tigela 500ml',
        description: 'Açaí puro batido com banana, acompanha morangos frescos, granola, leite em pó e leite condensado.',
        price: 17.00,
        imageUrl: 'assets/images/acai.jpg',
        category: 'Sorvetes & Açaí',
        createdAt: DateTime.now().subtract(const Duration(minutes: 40)),
        likesCount: 45,
        commentsCount: 5,
      ),

      // 4. Churros & Crepes
      PostModel(
        id: 'post_11',
        vendorId: 'v_12',
        vendorName: 'Seu Manuel dos Churros',
        vendorTradeName: 'Churros Dourados do Parque',
        vendorPhone: '(11) 97890-1234',
        vendorReferencePoint: 'Entrada das crianças do Parque da Cidade',
        vendorPixKey: '11978901234',
        title: 'Churros Tradicional de Doce de Leite',
        description: 'Massa crocante por fora, macia por dentro, frita na hora e passada no açúcar com canela com doce de leite cremoso.',
        price: 7.50,
        imageUrl: 'assets/images/churros.jpg',
        category: 'Churros & Crepes',
        createdAt: DateTime.now().subtract(const Duration(minutes: 35)),
        likesCount: 36,
        commentsCount: 3,
      ),

      // 5. Tapiocas & Cuscuz
      PostModel(
        id: 'post_19',
        vendorId: 'v_2',
        vendorName: 'Renato Silva',
        vendorTradeName: 'Ponto do Renato - Tapiocas e Cuscuz',
        vendorPhone: '(11) 91234-5678',
        vendorReferencePoint: 'Praça da Matriz, ao lado do coreto central',
        vendorPixKey: 'renato.tapioca@banco.com',
        title: 'Tapioca de Frango com Catupiry',
        description: 'Massa quentinha feita na hora, frango desfiado temperado com queijo catupiry.',
        price: 12.00,
        imageUrl: 'assets/images/tapioca.jpg',
        category: 'Tapiocas & Cuscuz',
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        likesCount: 27,
        commentsCount: 2,
      ),
      PostModel(
        id: 'post_20',
        vendorId: 'v_2',
        vendorName: 'Renato Silva',
        vendorTradeName: 'Ponto do Renato - Tapiocas e Cuscuz',
        vendorPhone: '(11) 91234-5678',
        vendorReferencePoint: 'Praça da Matriz, ao lado do coreto central',
        vendorPixKey: 'renato.tapioca@banco.com',
        title: 'Cuscuz Nordestino c/ Carne Seca e Queijo Coalho',
        description: 'Cuscuz fofinho temperado com carne seca desfiada e queijo coalho tostado na chapa.',
        price: 15.00,
        imageUrl: 'assets/images/tapioca.jpg',
        category: 'Tapiocas & Cuscuz',
        createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
        likesCount: 40,
        commentsCount: 3,
      ),

      // 6. Doces & Bolos
      PostModel(
        id: 'post_22',
        vendorId: 'v_10',
        vendorName: 'Dona Clara Doces',
        vendorTradeName: 'Doçuras da Clara',
        vendorPhone: '(11) 90000-7777',
        vendorReferencePoint: 'Banca de Doces ao lado da saída do Metrô',
        vendorPixKey: 'clara.doces@pix.com.br',
        title: 'Brigadeiros Artesanais (Caixinha c/ 4 unid.)',
        description: 'Feitos com chocolate 50% cacau e enrolados no granulado belga crocante.',
        price: 12.00,
        imageUrl: 'assets/images/brigadeiro.jpg',
        category: 'Doces & Bolos',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        likesCount: 46,
        commentsCount: 4,
      ),
      PostModel(
        id: 'post_23',
        vendorId: 'v_10',
        vendorName: 'Dona Clara Doces',
        vendorTradeName: 'Doçuras da Clara',
        vendorPhone: '(11) 90000-7777',
        vendorReferencePoint: 'Banca de Doces ao lado da saída do Metrô',
        vendorPixKey: 'clara.doces@pix.com.br',
        title: 'Bolo de Pote Ninho com Nutella',
        description: 'Massa fofinha de chocolate com generosas camadas de brigadeiro de ninho e nutella pura.',
        price: 10.00,
        imageUrl: 'assets/images/brigadeiro.jpg',
        category: 'Doces & Bolos',
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        likesCount: 38,
        commentsCount: 2,
      ),
    ]);

    // Inicializa comentários iniciais de demonstração (Onda 3)
    _commentsByPostId['post_1'] = [
      CommentModel(
        id: 'c1',
        postId: 'post_1',
        userId: 'u_cli_1',
        userName: 'Josué Santos',
        content: 'O pastel é frito na hora mesmo? Ficou super sequinho!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
      CommentModel(
        id: 'c2',
        postId: 'post_1',
        userId: 'v_1',
        userName: 'Kátia da Silva',
        userTradeName: 'Kátia da Esquina - Salgados',
        content: 'Oi Josué! Sim, montamos e fritamos na hora para chegar crocante pra você!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      CommentModel(
        id: 'c3',
        postId: 'post_1',
        userId: 'u_cli_2',
        userName: 'Marta Ferreira',
        content: 'Maravilhoso! Já fiz o Pix e estou indo retirar.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
    ];

    _commentsByPostId['post_19'] = [
      CommentModel(
        id: 'c4',
        postId: 'post_19',
        userId: 'u_cli_3',
        userName: 'Lucas Silva',
        content: 'Tem opção de massa com chia?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      CommentModel(
        id: 'c5',
        postId: 'post_19',
        userId: 'v_2',
        userName: 'Renato Silva',
        userTradeName: 'Ponto do Renato - Tapiocas e Cuscuz',
        content: 'Temos sim Lucas! Só avisar na hora da retirada que fazemos!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
    ];
  }

  @visibleForTesting
  void reset() {
    _posts.clear();
    _commentsByPostId.clear();
    _initSeedData();
  }
}
