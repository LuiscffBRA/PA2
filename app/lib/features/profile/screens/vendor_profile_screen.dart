import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pa2/core/theme/app_theme.dart';
import 'package:pa2/features/auth/models/user_model.dart';
import 'package:pa2/features/auth/services/auth_service.dart';
import 'package:pa2/features/feed/models/post_model.dart';
import 'package:pa2/features/feed/services/feed_service.dart';
import 'package:pa2/features/feed/widgets/post_card_widget.dart';
import 'package:pa2/features/chat/screens/chat_screen.dart';
import 'package:pa2/features/payments/widgets/pix_payment_modal.dart';

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

  Future<void> _openGoogleMaps(String locationQuery) async {
    final query = locationQuery.trim();
    if (query.isEmpty) return;

    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');
    try {
      final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        await launchUrl(url, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível abrir o mapa: $e')),
        );
      }
    }
  }

  void _showPixModal(UserModel vendor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PixPaymentModal(
        pixKey: vendor.pixKey?.isNotEmpty == true ? vendor.pixKey! : (vendor.phone ?? '11987654321'),
        pixKeyType: vendor.pixKeyType ?? 'Telefone',
        merchantName: vendor.name,
        merchantTradeName: (vendor.tradeName?.isNotEmpty == true) ? vendor.tradeName! : vendor.name,
        amount: 10.00, // Valor padrão de demonstração / customizável
        itemTitle: 'Pedido no ponto ${vendor.tradeName ?? vendor.name}',
      ),
    );
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
    final locationText = (vendor.referencePoint != null && vendor.referencePoint!.isNotEmpty)
        ? vendor.referencePoint!
        : 'Ponto de atendimento na vizinhança';

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
              padding: const EdgeInsets.only(bottom: 24, top: 10),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.white,
                    child: Text(
                      initialLetter,
                      style: const TextStyle(
                        fontSize: 38,
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
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Botões de Ação Rápida no Topo (Chat e PIX)
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.chat, size: 18),
                        label: const Text('Conversar (Chat)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondaryColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(160, 44),
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
                      ElevatedButton.icon(
                        icon: const Icon(Icons.qr_code_2, size: 18),
                        label: const Text('Pagar via PIX'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade700,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(150, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => _showPixModal(vendor),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Card de Localização / Ponto de Referência (Onda 3)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                color: Colors.blue.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: Colors.blue.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.blue.shade800, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            'Localização & Ponto de Venda',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        locationText,
                        style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary, height: 1.3),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.map_outlined, size: 18),
                        label: const Text('Abrir no Google Maps / Como Chegar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 42),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _openGoogleMaps(locationText),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Informações Sobre e Contato
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sobre',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    (vendor.bio != null && vendor.bio!.isNotEmpty) ? vendor.bio! : 'Sem descrição.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  
                  // Contato Telefone
                  Row(
                    children: [
                      const Icon(Icons.phone, color: AppTheme.primaryColor),
                      const SizedBox(width: 12),
                      Text(
                        (vendor.phone != null && vendor.phone!.isNotEmpty) ? vendor.phone! : 'Sem telefone',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  // Chave PIX
                  if (vendor.pixKey != null && vendor.pixKey!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.qr_code, color: Colors.teal),
                        const SizedBox(width: 12),
                        Text(
                          'PIX (${vendor.pixKeyType ?? "Chave"}): ${vendor.pixKey}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

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
                    child: Center(child: Text('Nenhuma postagem ativa no momento.', style: TextStyle(color: Colors.grey))),
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
