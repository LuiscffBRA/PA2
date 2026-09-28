import 'package:flutter/foundation.dart';
import 'package:pa2/features/auth/models/user_model.dart';
import '../models/post_model.dart';

class FeedService extends ChangeNotifier {
  static final FeedService _instance = FeedService._internal();
  factory FeedService() => _instance;
  FeedService._internal() {
    _initSeedData();
  }

  final List<PostModel> _posts = [];

  List<PostModel> get posts => List.unmodifiable(_posts);

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
        title: 'Pastel de Carne com Queijo na Hora',
        description: 'Massa crocante de feira, recheado com carne moída bem temperada e queijo derretido.',
        price: 9.50,
        imageUrl: 'assets/images/pastel.jpg',
        category: 'Pastéis & Salgados',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        likesCount: 28,
      ),
      PostModel(
        id: 'post_2',
        vendorId: 'v_1',
        vendorName: 'Kátia da Silva',
        vendorTradeName: 'Kátia da Esquina - Salgados',
        vendorPhone: '(11) 98765-4321',
        title: 'Coxinha Dourada de Frango com Catupiry',
        description: 'Massa artesanal super macia e recheio cremoso com muito frango desfiado.',
        price: 8.50,
        imageUrl: 'assets/images/coxinha.jpg',
        category: 'Pastéis & Salgados',
        createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
        likesCount: 34,
      ),
      PostModel(
        id: 'post_3',
        vendorId: 'v_1',
        vendorName: 'Kátia da Silva',
        vendorTradeName: 'Kátia da Esquina - Salgados',
        vendorPhone: '(11) 98765-4321',
        title: 'Pastel Especial de Palmito e Queijo',
        description: 'Recheio cremoso de palmito selecionado com bastante queijo mussarela derretido.',
        price: 10.00,
        imageUrl: 'assets/images/pastel.jpg',
        category: 'Pastéis & Salgados',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        likesCount: 15,
      ),
      PostModel(
        id: 'post_4',
        vendorId: 'v_3',
        vendorName: 'Dona Maria Salgadeira',
        vendorTradeName: 'Cantinho da Empada & Salgados',
        vendorPhone: '(11) 97777-1111',
        title: 'Pastel Frito Crocante de Carne',
        description: 'Pastel sequinho de feira com vinagrete à parte para acompanhar.',
        price: 9.00,
        imageUrl: 'assets/images/pastel.jpg',
        category: 'Pastéis & Salgados',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likesCount: 22,
      ),

      // 2. Esfihas & Árabe
      PostModel(
        id: 'post_5',
        vendorId: 'v_4',
        vendorName: 'Tariq Mansur',
        vendorTradeName: 'Tariq Esfiharia de Rua',
        vendorPhone: '(11) 96666-2222',
        title: 'Esfiha Aberta de Carne Temperada',
        description: 'Massa fininha e leve, recheada com carne moída, cebola, tomate fresco e toque de limão.',
        price: 6.50,
        imageUrl: 'assets/images/esfiha.jpg',
        category: 'Esfihas & Árabe',
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
        likesCount: 39,
      ),
      PostModel(
        id: 'post_6',
        vendorId: 'v_4',
        vendorName: 'Tariq Mansur',
        vendorTradeName: 'Tariq Esfiharia de Rua',
        vendorPhone: '(11) 96666-2222',
        title: 'Esfiha Aberta de Queijo Derretido',
        description: 'Massa macia com generosa cobertura de queijo derretido e orégano.',
        price: 7.00,
        imageUrl: 'assets/images/esfiha.jpg',
        category: 'Esfihas & Árabe',
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
        likesCount: 27,
      ),
      PostModel(
        id: 'post_7',
        vendorId: 'v_4',
        vendorName: 'Tariq Mansur',
        vendorTradeName: 'Tariq Esfiharia de Rua',
        vendorPhone: '(11) 96666-2222',
        title: 'Kibe Frito Recheado com Catupiry',
        description: 'Trigo selecionado, carne moída bem temperada com hortelã fresca e recheio cremoso.',
        price: 8.00,
        imageUrl: 'assets/images/coxinha.jpg',
        category: 'Esfihas & Árabe',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        likesCount: 23,
      ),

      // 3. Sorvetes & Açaí
      PostModel(
        id: 'post_8',
        vendorId: 'v_5',
        vendorName: 'Felipe Neves',
        vendorTradeName: 'Açaí & Sorvetes da Praça',
        vendorPhone: '(11) 95555-3333',
        title: 'Açaí Turbinado na Tigela 500ml',
        description: 'Açaí puro batido com banana, acompanha morangos frescos, granola, leite em pó e leite condensado.',
        price: 17.00,
        imageUrl: 'assets/images/acai.jpg',
        category: 'Sorvetes & Açaí',
        createdAt: DateTime.now().subtract(const Duration(minutes: 40)),
        likesCount: 45,
      ),
      PostModel(
        id: 'post_9',
        vendorId: 'v_5',
        vendorName: 'Felipe Neves',
        vendorTradeName: 'Açaí & Sorvetes da Praça',
        vendorPhone: '(11) 95555-3333',
        title: 'Taça de Sorvete Artesanal 2 Bolas',
        description: 'Sabores cremosos à sua escolha com calda de chocolate quente e castanhas.',
        price: 12.00,
        imageUrl: 'https://images.pexels.com/photos/1352278/pexels-photo-1352278.jpeg?auto=compress&cs=tinysrgb&w=800',
        category: 'Sorvetes & Açaí',
        createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 10)),
        likesCount: 31,
      ),
      PostModel(
        id: 'post_10',
        vendorId: 'v_5',
        vendorName: 'Felipe Neves',
        vendorTradeName: 'Açaí & Sorvetes da Praça',
        vendorPhone: '(11) 95555-3333',
        title: 'Picolé Gourmet Trufado',
        description: 'Casquinha crocante de chocolate belga com recheio cremoso de ninho trufado.',
        price: 6.00,
        imageUrl: 'https://images.pexels.com/photos/1362534/pexels-photo-1362534.jpeg?auto=compress&cs=tinysrgb&w=800',
        category: 'Sorvetes & Açaí',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        likesCount: 19,
      ),

      // 4. Churros & Crepes
      PostModel(
        id: 'post_11',
        vendorId: 'v_12',
        vendorName: 'Seu Manuel dos Churros',
        vendorTradeName: 'Churros Dourados do Parque',
        vendorPhone: '(11) 97890-1234',
        title: 'Churros Tradicional de Doce de Leite',
        description: 'Massa crocante por fora, macia por dentro, frita na hora e passada no açúcar com canela com doce de leite cremoso.',
        price: 7.50,
        imageUrl: 'assets/images/churros.jpg',
        category: 'Churros & Crepes',
        createdAt: DateTime.now().subtract(const Duration(minutes: 35)),
        likesCount: 36,
      ),
      PostModel(
        id: 'post_12',
        vendorId: 'v_12',
        vendorName: 'Seu Manuel dos Churros',
        vendorTradeName: 'Churros Dourados do Parque',
        vendorPhone: '(11) 97890-1234',
        title: 'Churros Espanhol com Chocolate Quente',
        description: 'Varetas finas e crocantes de churros servidas com calda densa de chocolate meio amargo.',
        price: 13.00,
        imageUrl: 'assets/images/churros.jpg',
        category: 'Churros & Crepes',
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 40)),
        likesCount: 28,
      ),
      PostModel(
        id: 'post_13',
        vendorId: 'v_12',
        vendorName: 'Seu Manuel dos Churros',
        vendorTradeName: 'Churros Dourados do Parque',
        vendorPhone: '(11) 97890-1234',
        title: 'Crepe Francês de Nutella com Morango',
        description: 'Massa fininha e dourada recheada com nutella pura e morangos frescos fatiados.',
        price: 16.00,
        imageUrl: 'assets/images/churros.jpg',
        category: 'Churros & Crepes',
        createdAt: DateTime.now().subtract(const Duration(hours: 3, minutes: 20)),
        likesCount: 25,
      ),

      // 5. Lanches & Hambúrguer
      PostModel(
        id: 'post_14',
        vendorId: 'v_7',
        vendorName: 'Marcos Burguer',
        vendorTradeName: 'Trailer do Marcos Burguer',
        vendorPhone: '(11) 93333-4444',
        title: 'X-Burguer Artesanal do Beco',
        description: 'Pão brioche selado na manteiga, blend bovino 150g, queijo cheddar e maionese verde.',
        price: 22.00,
        imageUrl: 'https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg?auto=compress&cs=tinysrgb&w=800',
        category: 'Lanches & Hambúrguer',
        createdAt: DateTime.now().subtract(const Duration(minutes: 50)),
        likesCount: 52,
      ),
      PostModel(
        id: 'post_15',
        vendorId: 'v_7',
        vendorName: 'Marcos Burguer',
        vendorTradeName: 'Trailer do Marcos Burguer',
        vendorPhone: '(11) 93333-4444',
        title: 'X-Salada Tradicional de Rua',
        description: 'Hambúrguer suculento, queijo prato derretido, alface americano fresco, tomate e molho especial.',
        price: 16.00,
        imageUrl: 'https://images.pexels.com/photos/1199957/pexels-photo-1199957.jpeg?auto=compress&cs=tinysrgb&w=800',
        category: 'Lanches & Hambúrguer',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likesCount: 37,
      ),
      PostModel(
        id: 'post_16',
        vendorId: 'v_8',
        vendorName: 'Tiago HotDog',
        vendorTradeName: 'Tiago Dogão Prensado',
        vendorPhone: '(11) 92222-5555',
        title: 'Hot Dog Prensado Completo',
        description: 'Duas salsichas, purê caseiro, milho, vinagrete, batata palha e queijo ralado.',
        price: 14.00,
        imageUrl: 'https://images.pexels.com/photos/4518656/pexels-photo-4518656.jpeg?auto=compress&cs=tinysrgb&w=800',
        category: 'Lanches & Hambúrguer',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        likesCount: 30,
      ),

      // 6. Pizzas & Massas
      PostModel(
        id: 'post_17',
        vendorId: 'v_9',
        vendorName: 'Pizzaiolo Giovanni',
        vendorTradeName: 'Giovanni Pizzas Brotinho',
        vendorPhone: '(11) 91111-6666',
        title: 'Pizza Brotinho de Calabresa Especial',
        description: 'Molho de tomate artesanal, muita calabresa fatiada, cebola e azeitonas pretas.',
        price: 18.00,
        imageUrl: 'https://images.pexels.com/photos/315755/pexels-photo-315755.jpeg?auto=compress&cs=tinysrgb&w=800',
        category: 'Pizzas & Massas',
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
        likesCount: 29,
      ),
      PostModel(
        id: 'post_18',
        vendorId: 'v_9',
        vendorName: 'Pizzaiolo Giovanni',
        vendorTradeName: 'Giovanni Pizzas Brotinho',
        vendorPhone: '(11) 91111-6666',
        title: 'Pizza Brotinho 4 Queijos Cremosa',
        description: 'Mussarela derretida, provolone defumado, parmesão e catupiry legítimo.',
        price: 20.00,
        imageUrl: 'https://images.pexels.com/photos/2147491/pexels-photo-2147491.jpeg?auto=compress&cs=tinysrgb&w=800',
        category: 'Pizzas & Massas',
        createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
        likesCount: 35,
      ),

      // 7. Tapiocas & Cuscuz
      PostModel(
        id: 'post_19',
        vendorId: 'v_2',
        vendorName: 'Renato Silva',
        vendorTradeName: 'Ponto do Renato - Tapiocas e Cuscuz',
        vendorPhone: '(11) 91234-5678',
        title: 'Tapioca de Frango com Catupiry',
        description: 'Massa quentinha feita na hora, frango desfiado temperado com queijo catupiry.',
        price: 12.00,
        imageUrl: 'assets/images/tapioca.jpg',
        category: 'Tapiocas & Cuscuz',
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        likesCount: 27,
      ),
      PostModel(
        id: 'post_20',
        vendorId: 'v_2',
        vendorName: 'Renato Silva',
        vendorTradeName: 'Ponto do Renato - Tapiocas e Cuscuz',
        vendorPhone: '(11) 91234-5678',
        title: 'Cuscuz Nordestino c/ Carne Seca e Queijo Coalho',
        description: 'Cuscuz fofinho temperado com carne seca desfiada e queijo coalho tostado na chapa.',
        price: 15.00,
        imageUrl: 'assets/images/tapioca.jpg',
        category: 'Tapiocas & Cuscuz',
        createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
        likesCount: 40,
      ),
      PostModel(
        id: 'post_21',
        vendorId: 'v_2',
        vendorName: 'Renato Silva',
        vendorTradeName: 'Ponto do Renato - Tapiocas e Cuscuz',
        vendorPhone: '(11) 91234-5678',
        title: 'Tapioca Doce de Coco e Leite Condensado',
        description: 'Massa fininha e macia com bastante coco ralado fresco e leite condensado.',
        price: 11.00,
        imageUrl: 'assets/images/tapioca.jpg',
        category: 'Tapiocas & Cuscuz',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        likesCount: 20,
      ),

      // 8. Doces & Bolos
      PostModel(
        id: 'post_22',
        vendorId: 'v_10',
        vendorName: 'Dona Clara Doces',
        vendorTradeName: 'Doçuras da Clara',
        vendorPhone: '(11) 90000-7777',
        title: 'Brigadeiros Artesanais (Caixinha c/ 4 unid.)',
        description: 'Feitos com chocolate 50% cacau e enrolados no granulado belga crocante.',
        price: 12.00,
        imageUrl: 'assets/images/brigadeiro.jpg',
        category: 'Doces & Bolos',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        likesCount: 46,
      ),
      PostModel(
        id: 'post_23',
        vendorId: 'v_10',
        vendorName: 'Dona Clara Doces',
        vendorTradeName: 'Doçuras da Clara',
        vendorPhone: '(11) 90000-7777',
        title: 'Bolo de Pote Ninho com Nutella',
        description: 'Massa fofinha de chocolate com generosas camadas de brigadeiro de ninho e nutella pura.',
        price: 10.00,
        imageUrl: 'assets/images/brigadeiro.jpg',
        category: 'Doces & Bolos',
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        likesCount: 38,
      ),
      PostModel(
        id: 'post_24',
        vendorId: 'v_10',
        vendorName: 'Dona Clara Doces',
        vendorTradeName: 'Doçuras da Clara',
        vendorPhone: '(11) 90000-7777',
        title: 'Pudim de Leite Condensado Tradicional',
        description: 'Pudim sem furinhos, extremamente cremoso com calda dourada de caramelo.',
        price: 8.00,
        imageUrl: 'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg?auto=compress&cs=tinysrgb&w=800',
        category: 'Doces & Bolos',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        likesCount: 29,
      ),

      // 9. Sucos & Bebidas
      PostModel(
        id: 'post_25',
        vendorId: 'v_11',
        vendorName: 'Carlos das Frutas',
        vendorTradeName: 'Trailer Suco Tropical',
        vendorPhone: '(11) 98888-0000',
        title: 'Suco Natural da Fruta 500ml',
        description: 'Feito na hora com polpa da fruta fresca (Laranja, Maracujá ou Acerola).',
        price: 7.00,
        imageUrl: 'https://images.pexels.com/photos/96974/pexels-photo-96974.jpeg?auto=compress&cs=tinysrgb&w=800',
        category: 'Sucos & Bebidas',
        createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
        likesCount: 23,
      ),
      PostModel(
        id: 'post_26',
        vendorId: 'v_11',
        vendorName: 'Carlos das Frutas',
        vendorTradeName: 'Trailer Suco Tropical',
        vendorPhone: '(11) 98888-0000',
        title: 'Caldo de Cana Moído com Limão 500ml',
        description: 'Moído na hora no ponto de venda, super gelado e com toque especial de limão taiti.',
        price: 6.00,
        imageUrl: 'https://images.pexels.com/photos/1337825/pexels-photo-1337825.jpeg?auto=compress&cs=tinysrgb&w=800',
        category: 'Sucos & Bebidas',
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
        likesCount: 39,
      ),
      PostModel(
        id: 'post_27',
        vendorId: 'v_11',
        vendorName: 'Carlos das Frutas',
        vendorTradeName: 'Trailer Suco Tropical',
        vendorPhone: '(11) 98888-0000',
        title: 'Água de Coco Gelada no Copo 500ml',
        description: '100% natural direto da fruta, tirada na hora para matar a sede no calor.',
        price: 6.50,
        imageUrl: 'https://images.pexels.com/photos/1200348/pexels-photo-1200348.jpeg?auto=compress&cs=tinysrgb&w=800',
        category: 'Sucos & Bebidas',
        createdAt: DateTime.now().subtract(const Duration(hours: 3, minutes: 40)),
        likesCount: 18,
      ),
    ]);
  }

  /// Cria uma nova postagem no feed
  Future<PostModel> createPost({
    required UserModel vendor,
    required String title,
    required String description,
    required double price,
    String? imageUrl,
    String? category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

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

    final newPost = PostModel(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      vendorId: vendor.id,
      vendorName: vendor.name,
      vendorTradeName: vendor.tradeName ?? vendor.name,
      vendorPhone: vendor.phone,
      title: title.trim(),
      description: description.trim(),
      price: price,
      imageUrl: imageUrl?.trim().isNotEmpty == true
          ? imageUrl!.trim()
          : 'assets/images/pastel.jpg',
      category: category?.trim(),
      createdAt: DateTime.now(),
    );

    _posts.insert(0, newPost);
    notifyListeners();
    return newPost;
  }

  @visibleForTesting
  void reset() {
    _posts.clear();
    _initSeedData();
  }
}
