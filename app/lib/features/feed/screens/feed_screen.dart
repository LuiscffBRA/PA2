import 'package:flutter/material.dart';
import 'package:pa2/core/theme/app_theme.dart';
import 'package:pa2/features/auth/services/auth_service.dart';
import '../models/food_catalog.dart';
import '../services/feed_service.dart';
import '../widgets/post_card_widget.dart';
import 'create_post_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _feedService = FeedService();
  final _authService = AuthService();

  String? _selectedCategoryFilter;

  @override
  void initState() {
    super.initState();
    _feedService.addListener(_onFeedChanged);
  }

  @override
  void dispose() {
    _feedService.removeListener(_onFeedChanged);
    super.dispose();
  }

  void _onFeedChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final allPosts = _feedService.posts;

    // Filtra postagens pela categoria selecionada no topo do feed
    final filteredPosts = _selectedCategoryFilter == null
        ? allPosts
        : allPosts.where((p) => p.category == _selectedCategoryFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pega Bode Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              _authService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      floatingActionButton: user?.isVendor == true
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreatePostScreen()),
                );
              },
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Criar Postagem'),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.only(top: 10, bottom: 80),
          children: [
            // Cartão de identificação do Usuário logado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.primaryLight,
                        child: Icon(
                          user?.isVendor == true ? Icons.storefront : Icons.person,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user != null ? 'Olá, ${user.name}!' : 'Bem-vindo!',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user?.isVendor == true
                                  ? 'Ponto: ${user?.tradeName ?? ""}'
                                  : 'Cliente da Vizinhança',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Barra de Filtros de Categoria (Rolar / Visualizar Feed dinâmico)
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      selected: _selectedCategoryFilter == null,
                      label: const Text('Todos'),
                      onSelected: (_) {
                        setState(() => _selectedCategoryFilter = null);
                      },
                      selectedColor: AppTheme.primaryColor,
                      labelStyle: TextStyle(
                        color: _selectedCategoryFilter == null ? Colors.white : AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...FoodCatalog.categories.map((cat) {
                    final isSelected = _selectedCategoryFilter == cat.name;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text('${cat.icon} ${cat.name}'),
                        onSelected: (_) {
                          setState(() {
                            _selectedCategoryFilter = isSelected ? null : cat.name;
                          });
                        },
                        selectedColor: AppTheme.primaryColor,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Lista de Postagens com Scroll Infinito / Pull-to-refresh
            if (filteredPosts.isEmpty)
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.fastfood_outlined, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 14),
                      Text(
                        _selectedCategoryFilter == null
                            ? 'Nenhuma postagem no momento.\nSeja o primeiro a publicar!'
                            : 'Nenhuma postagem em "$_selectedCategoryFilter".',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...filteredPosts.map((p) => PostCardWidget(post: p)),
          ],
        ),
      ),
    );
  }
}
