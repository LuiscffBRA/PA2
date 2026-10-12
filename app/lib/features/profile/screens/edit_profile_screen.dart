import 'package:flutter/material.dart';
import 'package:pa2/core/theme/app_theme.dart';
import 'package:pa2/features/auth/services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _tradeNameController;
  late TextEditingController _bioController;
  late TextEditingController _referencePointController;
  late TextEditingController _pixKeyController;
  String _selectedPixType = 'Telefone';

  final List<String> _pixTypes = [
    'Telefone',
    'CPF',
    'CNPJ',
    'E-mail',
    'Chave Aleatória',
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = _authService.currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _tradeNameController = TextEditingController(text: user?.tradeName ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _referencePointController = TextEditingController(text: user?.referencePoint ?? '');
    _pixKeyController = TextEditingController(text: user?.pixKey ?? '');
    if (user?.pixKeyType != null && _pixTypes.contains(user!.pixKeyType)) {
      _selectedPixType = user.pixKeyType!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _tradeNameController.dispose();
    _bioController.dispose();
    _referencePointController.dispose();
    _pixKeyController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = _authService.currentUser;
      final isVendor = user?.isVendor == true;

      await _authService.updateProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        tradeName: isVendor ? _tradeNameController.text.trim() : null,
        bio: _bioController.text.trim(),
        pixKey: isVendor ? _pixKeyController.text.trim() : null,
        pixKeyType: isVendor ? _selectedPixType : null,
        referencePoint: isVendor ? _referencePointController.text.trim() : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Perfil atualizado com sucesso!'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar perfil: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final isVendor = user?.isVendor == true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar
              Center(
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: AppTheme.primaryLight,
                  child: Icon(
                    isVendor ? Icons.storefront : Icons.person,
                    size: 44,
                    color: AppTheme.primaryDark,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Chip(
                  label: Text(
                    isVendor ? 'Conta de Vendedor Ambulante' : 'Conta de Cliente',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  backgroundColor: isVendor ? AppTheme.primaryLight.withOpacity(0.5) : Colors.grey.shade200,
                ),
              ),
              const SizedBox(height: 24),

              // Seção Dados Pessoais
              const Text(
                'Informações Pessoais',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 12),

              // Nome
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Informe o seu nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Telefone / WhatsApp
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: isVendor ? 'Telefone / WhatsApp de Vendas *' : 'Telefone / WhatsApp',
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
                validator: (val) {
                  if (isVendor && (val == null || val.trim().isEmpty)) {
                    return 'Vendedores devem informar um telefone de contato.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Seção Específica para Vendedor
              if (isVendor) ...[
                const Divider(),
                const SizedBox(height: 12),
                const Text(
                  'Dados do Ponto Comercial & Vendas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 12),

                // Nome Comercial
                TextFormField(
                  controller: _tradeNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome Comercial / Nome da Barraca *',
                    prefixIcon: Icon(Icons.storefront_outlined),
                    hintText: 'Ex: Kátia da Esquina - Salgados',
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Informe o nome comercial da sua barraca ou ponto.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Ponto de Referência / Localização (Onda 3)
                TextFormField(
                  controller: _referencePointController,
                  decoration: const InputDecoration(
                    labelText: 'Ponto de Referência / Localização *',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    hintText: 'Ex: Praça Central, ao lado do Coreto',
                    helperText: 'Aparece no botão "Como Chegar / Google Maps" para seus clientes.',
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Informe a localização ou ponto de referência.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Seção Chave PIX (Onda 3)
                const Divider(),
                const SizedBox(height: 12),
                const Text(
                  'Recebimento via PIX',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 12),

                // Tipo de Chave
                DropdownButtonFormField<String>(
                  value: _selectedPixType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Chave PIX',
                    prefixIcon: Icon(Icons.account_balance_outlined),
                  ),
                  items: _pixTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedPixType = val);
                  },
                ),
                const SizedBox(height: 14),

                // Chave PIX
                TextFormField(
                  controller: _pixKeyController,
                  decoration: InputDecoration(
                    labelText: 'Chave PIX',
                    prefixIcon: const Icon(Icons.qr_code_2),
                    hintText: _selectedPixType == 'Telefone'
                        ? 'Ex: 11999998888'
                        : _selectedPixType == 'CPF'
                            ? 'Ex: 123.456.789-00'
                            : _selectedPixType == 'E-mail'
                                ? 'Ex: seuemail@pix.com'
                                : 'Digite sua chave cadastrada',
                    helperText: 'Usada para gerar o QR Code e código Copia e Cola instantâneo.',
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Bio / Descrição
              const Divider(),
              const SizedBox(height: 12),
              const Text(
                'Sobre você / Bio',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bioController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descrição ou Apresentação',
                  prefixIcon: Icon(Icons.description_outlined),
                  hintText: 'Conte um pouco sobre os lanches, dias e horários em que atende...',
                ),
              ),
              const SizedBox(height: 30),

              // Botão Salvar
              ElevatedButton.icon(
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_isLoading ? 'Salvando...' : 'Salvar Alterações'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : _saveProfile,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
