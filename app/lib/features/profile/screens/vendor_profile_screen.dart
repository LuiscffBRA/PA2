import 'package:flutter/material.dart';
import 'package:pa2/core/theme/app_theme.dart';
import 'package:pa2/features/auth/models/user_model.dart';
import 'package:pa2/features/auth/services/auth_service.dart';
import 'package:pa2/features/feed/models/post_model.dart';
import 'package:pa2/features/feed/services/feed_service.dart';
import 'package:pa2/features/feed/widgets/post_card_widget.dart';
import 'package:pa2/features/chat/screens/chat_screen.dart';

class VendorProfileScreen extends StatefulWidget {
  final String vendorId;

  const VendorProfileScreen({super.key, required this.vendorId});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  UserModel? _vendorProfile;
  List<PostModel> _vendorPosts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfileAndPosts();
  }

  Future<void> _loadProfileAndPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final futures = await Future.wait([
        AuthService().getUserProfile(widget.vendorId),
        FeedService().fetchPostsByVendor(widget.vendorId),
      ]);

      final profile = futures[0] as UserModel?;
      final posts = futures[1] as List<PostModel>;

      if (profile == null) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Vendedor não encontrado.';
            _isLoading = false;
          });
        }
        return;
      }

      if (mounted) {
        setState(() {
          _vendorProfile = profile;
          _vendorPosts = posts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Carregando...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null || _vendorProfile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage ?? 'Vendedor não encontrado.', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProfileAndPosts,
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    final vendor = _vendorProfile!;
    final tradeNameSafe = (vendor.tradeName != null && vendor.tradeName!.isNotEmpty) ? vendor.tradeName! : vendor.name;
    final initialLetter = tradeNameSafe.isNotEmpty ? tradeNameSafe[0].toUpperCase() : 'V';

    return Scaffold(
      appBar: AppBar(
        title: Text(tradeNameSafe),
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header do Perfil
            Container(
              color: AppTheme.primaryColor,
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      initialLetter,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tradeNameSafe,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Por ${vendor.name}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.chat),
                        label: const Text('Conversar (Chat)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondaryColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(200, 50), // Override do double.infinity do AppTheme
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                otherUserId: vendor.id,
                                otherUserName: tradeNameSafe,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Informações
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sobre',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (vendor.bio != null && vendor.bio!.isNotEmpty) ? vendor.bio! : 'Sem descrição.',
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  
                  // Contato
                  Row(
                    children: [
                      const Icon(Icons.phone, color: AppTheme.primaryColor),
                      const SizedBox(width: 12),
                      Text(
                        (vendor.phone != null && vendor.phone!.isNotEmpty) ? vendor.phone! : 'Sem telefone',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 20),

                  // Postagens do Vendedor
                  Text(
                    'Lanches de $tradeNameSafe (${_vendorPosts.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            
            // Lista de posts
            _vendorPosts.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('Nenhuma postagem ativa.', style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _vendorPosts.length,
                    itemBuilder: (context, index) {
                      return PostCardWidget(post: _vendorPosts[index]);
                    },
                  ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
