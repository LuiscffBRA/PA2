class FoodCategory {
  final String id;
  final String name;
  final String icon;
  final List<FoodItemSuggestion> suggestions;

  const FoodCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.suggestions,
  });
}

class FoodItemSuggestion {
  final String name;
  final String defaultDescription;
  final double suggestedPrice;
  final String imageUrl;

  const FoodItemSuggestion({
    required this.name,
    required this.defaultDescription,
    required this.suggestedPrice,
    required this.imageUrl,
  });
}

class FoodCatalog {
  static const List<FoodCategory> categories = [
    // 1. Pastéis & Salgados
    FoodCategory(
      id: 'pasteis_salgados',
      name: 'Pastéis & Salgados',
      icon: '🥟',
      suggestions: [
        FoodItemSuggestion(
          name: 'Pastel de Carne com Queijo',
          defaultDescription: 'Massa crocante de feira, frito na hora, recheado com carne moída bem temperada e queijo derretido.',
          suggestedPrice: 9.50,
          imageUrl: 'assets/images/pastel.jpg',
        ),
        FoodItemSuggestion(
          name: 'Coxinha Dourada de Frango com Catupiry',
          defaultDescription: 'Massa artesanal super macia e crocante por fora, com muito frango desfiado e catupiry cremoso.',
          suggestedPrice: 8.50,
          imageUrl: 'assets/images/coxinha.jpg',
        ),
        FoodItemSuggestion(
          name: 'Pastel Especial de Palmito e Queijo',
          defaultDescription: 'Recheio farto de palmito selecionado e queijo mussarela derretido.',
          suggestedPrice: 10.00,
          imageUrl: 'assets/images/pastel.jpg',
        ),
      ],
    ),

    // 2. Esfihas & Árabe
    FoodCategory(
      id: 'esfihas_arabe',
      name: 'Esfihas & Árabe',
      icon: '🫓',
      suggestions: [
        FoodItemSuggestion(
          name: 'Esfiha Aberta de Carne Temperada',
          defaultDescription: 'Massa fininha e leve, recheada com carne moída, cebola, tomate fresco e toque de limão.',
          suggestedPrice: 6.50,
          imageUrl: 'assets/images/esfiha.jpg',
        ),
        FoodItemSuggestion(
          name: 'Esfiha Aberta de Queijo Derretido',
          defaultDescription: 'Massa macia com generosa cobertura de queijo derretido e orégano.',
          suggestedPrice: 7.00,
          imageUrl: 'assets/images/esfiha.jpg',
        ),
        FoodItemSuggestion(
          name: 'Kibe Frito Recheado com Catupiry',
          defaultDescription: 'Trigo selecionado, carne moída bem temperada com hortelã fresca e recheio cremoso.',
          suggestedPrice: 8.00,
          imageUrl: 'assets/images/coxinha.jpg',
        ),
      ],
    ),

    // 3. Sorvetes & Açaí
    FoodCategory(
      id: 'sorvetes_acai',
      name: 'Sorvetes & Açaí',
      icon: '🍨',
      suggestions: [
        FoodItemSuggestion(
          name: 'Tigela / Copo de Açaí Turbinado 500ml',
          defaultDescription: 'Açaí puro batido com banana, acompanha morangos, leite em pó, granola crocante e leite condensado.',
          suggestedPrice: 17.00,
          imageUrl: 'assets/images/acai.jpg',
        ),
        FoodItemSuggestion(
          name: 'Taça de Sorvete Artesanal 2 Bolas',
          defaultDescription: 'Sabores cremosos à sua escolha com calda de chocolate quente e castanhas.',
          suggestedPrice: 12.00,
          imageUrl: 'https://images.pexels.com/photos/1352278/pexels-photo-1352278.jpeg?auto=compress&cs=tinysrgb&w=800',
        ),
        FoodItemSuggestion(
          name: 'Picolé Gourmet Trufado',
          defaultDescription: 'Casquinha crocante de chocolate com recheio cremoso de ninho trufado.',
          suggestedPrice: 6.00,
          imageUrl: 'https://images.pexels.com/photos/1362534/pexels-photo-1362534.jpeg?auto=compress&cs=tinysrgb&w=800',
        ),
      ],
    ),

    // 4. Lanches & Hambúrguer
    FoodCategory(
      id: 'lanches_hamburguer',
      name: 'Lanches & Hambúrguer',
      icon: '🍔',
      suggestions: [
        FoodItemSuggestion(
          name: 'X-Burguer Artesanal do Beco',
          defaultDescription: 'Pão brioche selado na manteiga, blend bovino 150g, queijo cheddar derretido e maionese verde.',
          suggestedPrice: 22.00,
          imageUrl: 'https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg?auto=compress&cs=tinysrgb&w=800',
        ),
        FoodItemSuggestion(
          name: 'X-Salada Tradicional de Rua',
          defaultDescription: 'Hambúrguer suculento, queijo prato derretido, alface americano fresco, tomate e molho especial.',
          suggestedPrice: 16.00,
          imageUrl: 'https://images.pexels.com/photos/1199957/pexels-photo-1199957.jpeg?auto=compress&cs=tinysrgb&w=800',
        ),
        FoodItemSuggestion(
          name: 'Hot Dog Prensado Completo',
          defaultDescription: 'Duas salsichas, purê caseiro, milho, vinagrete, batata palha e queijo ralado.',
          suggestedPrice: 14.00,
          imageUrl: 'https://images.pexels.com/photos/4518656/pexels-photo-4518656.jpeg?auto=compress&cs=tinysrgb&w=800',
        ),
      ],
    ),

    // 5. Pizzas & Massas
    FoodCategory(
      id: 'pizza_massas',
      name: 'Pizzas & Massas',
      icon: '🍕',
      suggestions: [
        FoodItemSuggestion(
          name: 'Pizza Brotinho de Calabresa Especial',
          defaultDescription: 'Molho de tomate artesanal, muita calabresa fatiada, cebola e azeitonas pretas.',
          suggestedPrice: 18.00,
          imageUrl: 'https://images.pexels.com/photos/315755/pexels-photo-315755.jpeg?auto=compress&cs=tinysrgb&w=800',
        ),
        FoodItemSuggestion(
          name: 'Pizza Brotinho 4 Queijos Cremosa',
          defaultDescription: 'Mussarela derretida, provolone defumado, parmesão e catupiry legítimo.',
          suggestedPrice: 20.00,
          imageUrl: 'https://images.pexels.com/photos/2147491/pexels-photo-2147491.jpeg?auto=compress&cs=tinysrgb&w=800',
        ),
      ],
    ),

    // 6. Tapiocas & Cuscuz
    FoodCategory(
      id: 'tapiocas_nordeste',
      name: 'Tapiocas & Cuscuz',
      icon: '🥞',
      suggestions: [
        FoodItemSuggestion(
          name: 'Tapioca de Frango com Catupiry',
          defaultDescription: 'Massa quentinha feita na hora, frango desfiado temperado com queijo catupiry.',
          suggestedPrice: 12.00,
          imageUrl: 'assets/images/tapioca.jpg',
        ),
        FoodItemSuggestion(
          name: 'Cuscuz Nordestino c/ Carne Seca e Queijo Coalho',
          defaultDescription: 'Cuscuz fofinho temperado com carne seca desfiada e queijo coalho tostado na chapa.',
          suggestedPrice: 15.00,
          imageUrl: 'assets/images/tapioca.jpg',
        ),
        FoodItemSuggestion(
          name: 'Tapioca Doce de Coco e Leite Condensado',
          defaultDescription: 'Massa fininha e macia com bastante coco ralado fresco e leite condensado.',
          suggestedPrice: 11.00,
          imageUrl: 'assets/images/tapioca.jpg',
        ),
      ],
    ),

    // 7. Churros & Crepes
    FoodCategory(
      id: 'churros_crepes',
      name: 'Churros & Crepes',
      icon: '🥖',
      suggestions: [
        FoodItemSuggestion(
          name: 'Churros Tradicional de Doce de Leite',
          defaultDescription: 'Massa crocante por fora, macia por dentro, frita na hora e passada no açúcar com canela com recheio cremoso.',
          suggestedPrice: 7.50,
          imageUrl: 'assets/images/churros.jpg',
        ),
        FoodItemSuggestion(
          name: 'Churros Espanhol com Chocolate Quente',
          defaultDescription: 'Varetas finas e crocantes de churros servidas com calda densa de chocolate meio amargo.',
          suggestedPrice: 13.00,
          imageUrl: 'assets/images/churros.jpg',
        ),
        FoodItemSuggestion(
          name: 'Crepe Francês de Nutella com Morango',
          defaultDescription: 'Massa fininha e dourada recheada com nutella pura e morangos frescos fatiados.',
          suggestedPrice: 16.00,
          imageUrl: 'assets/images/churros.jpg',
        ),
      ],
    ),

    // 8. Doces & Bolos
    FoodCategory(
      id: 'doces_sobremesas',
      name: 'Doces & Bolos',
      icon: '🍰',
      suggestions: [
        FoodItemSuggestion(
          name: 'Brigadeiros Artesanais (Caixinha c/ 4 unid.)',
          defaultDescription: 'Feitos com chocolate 50% cacau e enrolados no granulado belga crocante.',
          suggestedPrice: 12.00,
          imageUrl: 'assets/images/brigadeiro.jpg',
        ),
        FoodItemSuggestion(
          name: 'Bolo de Pote Ninho com Nutella',
          defaultDescription: 'Massa fofinha de chocolate com generosas camadas de brigadeiro de ninho e nutella pura.',
          suggestedPrice: 10.00,
          imageUrl: 'assets/images/brigadeiro.jpg',
        ),
        FoodItemSuggestion(
          name: 'Pudim de Leite Condensado da Vovó',
          defaultDescription: 'Pudim super lisinho, cremoso, com calda dourada de caramelo.',
          suggestedPrice: 8.00,
          imageUrl: 'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg?auto=compress&cs=tinysrgb&w=800',
        ),
      ],
    ),

    // 9. Sucos & Bebidas
    FoodCategory(
      id: 'bebidas_sucos',
      name: 'Sucos & Bebidas',
      icon: '🥤',
      suggestions: [
        FoodItemSuggestion(
          name: 'Suco Natural da Fruta 500ml',
          defaultDescription: 'Feito na hora com polpa da fruta fresca (Laranja, Maracujá ou Acerola).',
          suggestedPrice: 7.00,
          imageUrl: 'https://images.pexels.com/photos/96974/pexels-photo-96974.jpeg?auto=compress&cs=tinysrgb&w=800',
        ),
        FoodItemSuggestion(
          name: 'Caldo de Cana Moído com Limão 500ml',
          defaultDescription: 'Cana fresca moída na hora no ponto do ambulante, super gelado.',
          suggestedPrice: 6.00,
          imageUrl: 'https://images.pexels.com/photos/1337825/pexels-photo-1337825.jpeg?auto=compress&cs=tinysrgb&w=800',
        ),
        FoodItemSuggestion(
          name: 'Água de Coco Gelada no Copo 500ml',
          defaultDescription: '100% natural direto da fruta, geladinha para refrescar.',
          suggestedPrice: 6.50,
          imageUrl: 'https://images.pexels.com/photos/1200348/pexels-photo-1200348.jpeg?auto=compress&cs=tinysrgb&w=800',
        ),
      ],
    ),
  ];
}
