import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  // Singleton para acesso global na aplicação
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final Map<String, ({UserModel user, String password})> _usersDatabase = {};
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  /// Registra um novo usuário (Cliente ou Vendedor)
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required UserType userType,
    String? phone,
    String? tradeName,
    String? bio,
  }) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 300));

    final normalizedEmail = email.trim().toLowerCase();

    if (normalizedEmail.isEmpty || !normalizedEmail.contains('@')) {
      throw Exception('Informe um e-mail válido.');
    }

    if (name.trim().isEmpty) {
      throw Exception('Informe o seu nome.');
    }

    if (password.length < 6) {
      throw Exception('A senha deve ter no mínimo 6 caracteres.');
    }

    if (userType == UserType.vendor) {
      if (tradeName == null || tradeName.trim().isEmpty) {
        throw Exception('Vendedores devem informar o Nome Comercial / Ponto de Venda.');
      }
      if (phone == null || phone.trim().isEmpty) {
        throw Exception('Vendedores devem informar o Telefone / WhatsApp de contato.');
      }
    }

    if (_usersDatabase.containsKey(normalizedEmail)) {
      throw Exception('Este e-mail já está cadastrado no sistema.');
    }

    final newUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: normalizedEmail,
      userType: userType,
      phone: phone?.trim(),
      tradeName: tradeName?.trim(),
      bio: bio?.trim(),
    );

    _usersDatabase[normalizedEmail] = (user: newUser, password: password);
    _currentUser = newUser;
    notifyListeners();

    return newUser;
  }

  /// Efetua login com e-mail e senha
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final normalizedEmail = email.trim().toLowerCase();
    final record = _usersDatabase[normalizedEmail];

    if (record == null || record.password != password) {
      throw Exception('E-mail ou senha incorretos.');
    }

    _currentUser = record.user;
    notifyListeners();
    return _currentUser!;
  }

  /// Desconecta o usuário atual
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  /// Limpa banco em memória (útil para testes unitários)
  @visibleForTesting
  void reset() {
    _usersDatabase.clear();
    _currentUser = null;
  }
}
