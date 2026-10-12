import 'package:flutter/material.dart';
import 'package:pa2/core/theme/app_theme.dart';
import 'package:pa2/features/auth/models/user_model.dart';
import 'package:pa2/features/auth/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  UserType _selectedUserType = UserType.client;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _tradeNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  final _pixKeyController = TextEditingController();
  final _referencePointController = TextEditingController();
  String _selectedPixType = 'Telefone';

  final List<String> _pixTypes = [
    'Telefone',
    'CPF',
    'CNPJ',
    'E-mail',
    'Chave Aleatória',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _tradeNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _pixKeyController.dispose();
    _referencePointController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = await _authService.register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        userType: _selectedUserType,
        tradeName: _selectedUserType == UserType.vendor ? _tradeNameController.text : null,
        phone: _selectedUserType == UserType.vendor ? _phoneController.text : null,
        bio: _selectedUserType == UserType.vendor ? _bioController.text : null,
        pixKey: _selectedUserType == UserType.vendor ? _pixKeyController.text : null,
        pixKeyType: _selectedUserType == UserType.vendor ? _selectedPixType : null,
        referencePoint: _selectedUserType == UserType.vendor ? _referencePointController.text : null,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Conta criada com sucesso! Bem-vindo(a), ${user.name}!'),
          backgroundColor: AppTheme.secondaryColor,
        ),
      );

      // Redireciona para o Feed
      Navigator.pushReplacementNamed(context, '/main');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVendor = _selectedUserType == UserType.vendor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Cadastre-se no AchaNaRua',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Compre e venda produtos locais de forma rápida e direta.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),

                // Seletor de Perfil
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedUserType = UserType.client),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isVendor ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: !isVendor
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 20,
                                  color: !isVendor ? AppTheme.primaryColor : Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Sou Cliente',
                                  style: TextStyle(
                                    fontWeight: !isVendor ? FontWeight.bold : FontWeight.normal,
                                    color: !isVendor ? AppTheme.primaryColor : Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedUserType = UserType.vendor),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isVendor ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: isVendor
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.store_mall_directory_outlined,
                                  size: 20,
                                  color: isVendor ? AppTheme.primaryColor : Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Sou Vendedor',
                                  style: TextStyle(
                                    fontWeight: isVendor ? FontWeight.bold : FontWeight.normal,
                                    color: isVendor ? AppTheme.primaryColor : Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome Completo',
                    prefixIcon: Icon(Icons.badge_outlined),
                    hintText: 'Ex: Maria da Silva',
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe seu nome completo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: 'exemplo@email.com',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe seu e-mail';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Informe um e-mail válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                if (isVendor) ...[
                  TextFormField(
                    controller: _tradeNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Ponto / Barraca',
                      prefixIcon: Icon(Icons.storefront_outlined),
                      hintText: 'Ex: Tapioca da Kátia, Salgados do Renato',
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (isVendor && (value == null || value.trim().isEmpty)) {
                        return 'Informe o nome do seu ponto de venda';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Telefone / WhatsApp',
                      prefixIcon: Icon(Icons.phone_android_outlined),
                      hintText: '(00) 90000-0000',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (isVendor && (value == null || value.trim().isEmpty)) {
                        return 'Informe o seu WhatsApp de contato';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: 'Bio / Descrição do que vende',
                      prefixIcon: Icon(Icons.description_outlined),
                      hintText: 'Ex: Salgados, pastéis e sucos frescos todos os dias.',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _referencePointController,
                    decoration: const InputDecoration(
                      labelText: 'Ponto de Referência / Localização',
                      prefixIcon: Icon(Icons.location_on_outlined),
                      hintText: 'Ex: Praça Central, em frente à igreja',
                      helperText: 'Usado para orientar seus clientes no mapa.',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Seção PIX para Vendedores
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.teal.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.qr_code_2, color: Colors.teal, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Recebimento via PIX (Onda 3)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Informe sua chave Pix real cadastrada no seu banco para os clientes gerarem o QR Code e pagarem direto para sua conta:',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _selectedPixType,
                          decoration: const InputDecoration(
                            labelText: 'Tipo de Chave PIX',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: _pixTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedPixType = val);
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _pixKeyController,
                          decoration: InputDecoration(
                            labelText: 'Chave PIX Real',
                            filled: true,
                            fillColor: Colors.white,
                            hintText: _selectedPixType == 'Telefone'
                                ? 'Ex: 11999998888'
                                : _selectedPixType == 'CPF'
                                    ? 'Ex: 12345678900'
                                    : _selectedPixType == 'E-mail'
                                        ? 'Ex: seu@email.com'
                                        : 'Digite a chave exata',
                            helperText: 'Você também pode editar ou alterar essa chave no seu perfil mais tarde.',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe uma senha';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter no mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    prefixIcon: const Icon(Icons.lock_clock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),
                  obscureText: _obscureConfirmPassword,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text('Cadastrar e Começar'),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Já possui uma conta? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'Fazer Login',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
