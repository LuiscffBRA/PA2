import 'package:flutter/material.dart';
import 'package:pa2/core/theme/app_theme.dart';
import 'package:pa2/features/auth/services/auth_service.dart';
import 'package:pa2/features/profile/screens/edit_profile_screen.dart';
import 'package:pa2/features/profile/screens/vendor_profile_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _authService.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    _authService.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Meu Perfil')),
        body: const Center(child: Text('Nenhum usuário logado.')),
      );
    }

    final isVendor = user.isVendor;
    final displayName = user.tradeName?.isNotEmpty == true ? user.tradeName! : user.name;
    final initialLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar Perfil',
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
              if (updated == true && mounted) {
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: AppTheme.primaryLight,
                    child: Text(
                      initialLetter,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    displayName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  if (isVendor && user.tradeName?.isNotEmpty == true) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Responsável: ${user.name}',
                      style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isVendor ? AppTheme.primaryLight.withOpacity(0.5) : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isVendor ? '🏪 Vendedor Ambulante' : '👤 Cliente',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isVendor ? AppTheme.primaryDark : Colors.grey.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Editar Dados do Perfil'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(220, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                      );
                      if (updated == true && mounted) {
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Seção de Detalhes
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dados da Conta',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoTile(Icons.email_outlined, 'E-mail', user.email),
                  _buildInfoTile(
                    Icons.phone_outlined,
                    'Telefone / WhatsApp',
                    user.phone?.isNotEmpty == true ? user.phone! : 'Não informado',
                  ),
                  if (user.bio?.isNotEmpty == true)
                    _buildInfoTile(Icons.info_outline, 'Sobre / Bio', user.bio!),
                  
                  if (isVendor) ...[
                    const Divider(height: 24),
                    const Text(
                      'Ponto de Venda & Pagamento',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoTile(
                      Icons.location_on_outlined,
                      'Ponto de Referência / Localização',
                      user.referencePoint?.isNotEmpty == true
                          ? user.referencePoint!
                          : 'Adicione um ponto de referência para abrir no Maps',
                    ),
                    _buildInfoTile(
                      Icons.qr_code_2,
                      'Chave PIX (${user.pixKeyType ?? "Padrão"})',
                      user.pixKey?.isNotEmpty == true ? user.pixKey! : 'Nenhuma chave cadastrada',
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.storefront, size: 18),
                      label: const Text('Ver meu Perfil Público de Vendedor'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 42),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VendorProfileScreen(vendorId: user.id),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Botão Sair
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Sair do Aplicativo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              _authService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
