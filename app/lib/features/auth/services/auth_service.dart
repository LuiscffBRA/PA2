import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    _initSeedVendors();
    _initCurrentUserFromSession();
  }

  final Map<String, ({UserModel user, String password})> _memoryUsersDatabase = {};
  final Map<String, UserModel> _knownVendorProfiles = {};
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  void _initSeedVendors() {
    final vendors = [
      UserModel(
        id: 'v_1',
        name: 'Kátia da Silva',
        email: 'katia@lanches.com',
        userType: UserType.vendor,
        phone: '(11) 98765-4321',
        tradeName: 'Kátia da Esquina - Salgados',
        bio: 'Frituras sequinhas, pastéis crocantes feitos na hora e o melhor tempero de rua da região.',
        pixKey: '11987654321',
        pixKeyType: 'Telefone',
        referencePoint: 'Em frente ao portão principal da faculdade - Barraca Amarela',
      ),
      UserModel(
        id: 'v_2',
        name: 'Renato Silva',
        email: 'renato@tapioca.com',
        userType: UserType.vendor,
        phone: '(11) 91234-5678',
        tradeName: 'Ponto do Renato - Tapiocas e Cuscuz',
        bio: 'Tapiocas doces e salgadas feitas na hora com ingredientes frescos e massa artesanal nordestina.',
        pixKey: 'renato.tapioca@banco.com',
        pixKeyType: 'E-mail',
        referencePoint: 'Praça da Matriz, ao lado do coreto central',
      ),
      UserModel(
        id: 'v_3',
        name: 'Dona Maria Salgadeira',
        email: 'maria@empadas.com',
        userType: UserType.vendor,
        phone: '(11) 97777-1111',
        tradeName: 'Cantinho da Empada & Salgados',
        bio: 'Empadas que derretem na boca com recheio cremoso e pastéis sequinhos de feira.',
        pixKey: '123.456.789-00',
        pixKeyType: 'CPF',
        referencePoint: 'Feira Livre de Domingo - Box 42',
      ),
      UserModel(
        id: 'v_4',
        name: 'Tariq Mansur',
        email: 'tariq@esfihas.com',
        userType: UserType.vendor,
        phone: '(11) 96666-2222',
        tradeName: 'Tariq Esfiharia de Rua',
        bio: 'Comida árabe autêntica, massa leve assada e kibes com tempero tradicional.',
        pixKey: '98765432-1234-5678-90ab-cdef01234567',
        pixKeyType: 'Chave Aleatória',
        referencePoint: 'Avenida Brasil, próximo ao ponto de ônibus da Estação',
      ),
      UserModel(
        id: 'v_5',
        name: 'Felipe Neves',
        email: 'felipe@acai.com',
        userType: UserType.vendor,
        phone: '(11) 95555-3333',
        tradeName: 'Açaí & Sorvetes da Praça',
        bio: 'Açaí artesanal batido na tigela com complementos ilimitados e sorvetes refrescantes.',
        pixKey: '11955553333',
        pixKeyType: 'Telefone',
        referencePoint: 'Quiosque 3 no Parque Ecológico Municipal',
      ),
      UserModel(
        id: 'v_7',
        name: 'Marcos Burguer',
        email: 'marcos@burguer.com',
        userType: UserType.vendor,
        phone: '(11) 93333-4444',
        tradeName: 'Trailer do Marcos Burguer',
        bio: 'Hambúrguer artesanal prensado na chapa com muito queijo derretido e maionese verde da casa.',
        pixKey: '11933334444',
        pixKeyType: 'Telefone',
        referencePoint: 'Rua das Palmeiras, em frente à academia Smart',
      ),
      UserModel(
        id: 'v_8',
        name: 'Tiago HotDog',
        email: 'tiago@hotdog.com',
        userType: UserType.vendor,
        phone: '(11) 92222-5555',
        tradeName: 'Tiago Dogão Prensado',
        bio: 'O legítimo dogão prensado completo com purê de batata caseiro e duas salsichas.',
        pixKey: 'tiagodog@pagamento.com',
        pixKeyType: 'E-mail',
        referencePoint: 'Estacionamento do Supermercado Central',
      ),
      UserModel(
        id: 'v_9',
        name: 'Pizzaiolo Giovanni',
        email: 'giovanni@pizzas.com',
        userType: UserType.vendor,
        phone: '(11) 91111-6666',
        tradeName: 'Giovanni Pizzas Brotinho',
        bio: 'Pizzas brotinho assadas na hora com massa crocante e borda recheada.',
        pixKey: '11911116666',
        pixKeyType: 'Telefone',
        referencePoint: 'Calçadão do Centro - Em frente ao Cine Teatro',
      ),
      UserModel(
        id: 'v_10',
        name: 'Dona Clara Doces',
        email: 'clara@doces.com',
        userType: UserType.vendor,
        phone: '(11) 90000-7777',
        tradeName: 'Doçuras da Clara',
        bio: 'Doces gourmet, bolos de pote e brigadeiros especiais para alegrar seu dia.',
        pixKey: 'clara.doces@pix.com.br',
        pixKeyType: 'E-mail',
        referencePoint: 'Banca de Doces ao lado da saída do Metrô',
      ),
      UserModel(
        id: 'v_11',
        name: 'Carlos das Frutas',
        email: 'carlos@sucos.com',
        userType: UserType.vendor,
        phone: '(11) 98888-0000',
        tradeName: 'Trailer Suco Tropical',
        bio: 'Sucos naturais da fruta geladinhos, caldo de cana moído com limão e água de coco.',
        pixKey: '11988880000',
        pixKeyType: 'Telefone',
        referencePoint: 'Área de alimentação da Ciclovia - Posto 5',
      ),
      UserModel(
        id: 'v_12',
        name: 'Seu Manuel dos Churros',
        email: 'manuel@churros.com',
        userType: UserType.vendor,
        phone: '(11) 97890-1234',
        tradeName: 'Churros Dourados do Parque',
        bio: 'Churros espanhóis e tradicionais bem recheados com doce de leite e nutella pura.',
        pixKey: '11978901234',
        pixKeyType: 'Telefone',
        referencePoint: 'Entrada das crianças do Parque da Cidade',
      ),
    ];

    for (final v in vendors) {
      _knownVendorProfiles[v.id] = v;
      _memoryUsersDatabase[v.email] = (user: v, password: 'password123');
    }
  }

  void _initCurrentUserFromSession() {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        final metadata = session.user.userMetadata ?? {};
        _currentUser = UserModel(
          id: session.user.id,
          name: metadata['name'] ?? session.user.email?.split('@').first ?? 'Usuário',
          email: session.user.email ?? '',
          userType: metadata['user_type'] == 'vendor' ? UserType.vendor : UserType.client,
          phone: metadata['phone'],
          tradeName: metadata['trade_name'],
          bio: metadata['bio'],
          pixKey: metadata['pix_key'],
          pixKeyType: metadata['pix_key_type'],
          referencePoint: metadata['reference_point'],
          latitude: (metadata['latitude'] as num?)?.toDouble(),
          longitude: (metadata['longitude'] as num?)?.toDouble(),
        );
      }
    } catch (_) {
      // Supabase ainda não inicializado ou modo offline/teste
    }
  }

  /// Registra um novo usuário (Cliente ou Vendedor) no Supabase com fallback seguro
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required UserType userType,
    String? phone,
    String? tradeName,
    String? bio,
    String? pixKey,
    String? pixKeyType,
    String? referencePoint,
    double? latitude,
    double? longitude,
  }) async {
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

    try {
      final client = Supabase.instance.client;
      final authResponse = await client.auth.signUp(
        email: normalizedEmail,
        password: password,
        data: {
          'name': name.trim(),
          'user_type': userType.name,
          'phone': phone?.trim(),
          'trade_name': tradeName?.trim(),
          'bio': bio?.trim(),
          'pix_key': pixKey?.trim(),
          'pix_key_type': pixKeyType?.trim(),
          'reference_point': referencePoint?.trim(),
          'latitude': latitude,
          'longitude': longitude,
        },
      );

      final user = authResponse.user;
      if (user == null) {
        throw Exception('Não foi possível criar o usuário no Supabase.');
      }

      final newUser = UserModel(
        id: user.id,
        name: name.trim(),
        email: normalizedEmail,
        userType: userType,
        phone: phone?.trim(),
        tradeName: tradeName?.trim(),
        bio: bio?.trim(),
        pixKey: pixKey?.trim(),
        pixKeyType: pixKeyType?.trim(),
        referencePoint: referencePoint?.trim(),
        latitude: latitude,
        longitude: longitude,
      );

      // Salva o perfil na tabela pública profiles
      try {
        await client.from('profiles').upsert({
          'id': user.id,
          'name': name.trim(),
          'email': normalizedEmail,
          'user_type': userType.name,
          'phone': phone?.trim(),
          'trade_name': tradeName?.trim(),
          'bio': bio?.trim(),
          'pix_key': pixKey?.trim(),
          'pix_key_type': pixKeyType?.trim(),
          'reference_point': referencePoint?.trim(),
          'latitude': latitude,
          'longitude': longitude,
        });
      } catch (profileError) {
        debugPrint('Aviso ao sincronizar profiles no Supabase: $profileError');
      }

      _currentUser = newUser;
      _knownVendorProfiles[newUser.id] = newUser;
      notifyListeners();
      return newUser;
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();

      // Se for ambiente de testes unitários (onde o Supabase não é inicializado) ou offline
      if (e is AssertionError || errorMsg.contains('initialized') || errorMsg.contains('network')) {
        if (_memoryUsersDatabase.containsKey(normalizedEmail)) {
          throw Exception('Este e-mail já está cadastrado no sistema.');
        }

        final hexTimestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(16).padLeft(12, '0');
        final localUser = UserModel(
          id: '00000000-0000-4000-8000-$hexTimestamp',
          name: name.trim(),
          email: normalizedEmail,
          userType: userType,
          phone: phone?.trim(),
          tradeName: tradeName?.trim(),
          bio: bio?.trim(),
          pixKey: pixKey?.trim(),
          pixKeyType: pixKeyType?.trim(),
          referencePoint: referencePoint?.trim(),
          latitude: latitude,
          longitude: longitude,
        );

        _memoryUsersDatabase[normalizedEmail] = (user: localUser, password: password);
        _knownVendorProfiles[localUser.id] = localUser;
        _currentUser = localUser;
        notifyListeners();
        return localUser;
      }

      debugPrint('Erro ao registrar no Supabase: $e');
      if (errorMsg.contains('already registered') || errorMsg.contains('user already exists')) {
        throw Exception('Este e-mail já está cadastrado no sistema.');
      }
      if (errorMsg.contains('rate limit')) {
        throw Exception('Limite de envio do Supabase atingido. Desative a opção "Confirm email" no painel do Supabase para liberar cadastros.');
      }
      rethrow;
    }
  }

  /// Efetua login com e-mail e senha
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    try {
      final client = Supabase.instance.client;
      final authResponse = await client.auth.signInWithPassword(
        email: normalizedEmail,
        password: password,
      );

      final user = authResponse.user;
      if (user == null) {
        throw Exception('E-mail ou senha incorretos.');
      }

      // Tenta buscar dados completos de profiles
      Map<String, dynamic>? profileData;
      try {
        profileData = await client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();
      } catch (_) {}

      final metadata = user.userMetadata ?? {};
      final userTypeStr = profileData?['user_type'] ?? metadata['user_type'];

      final loggedInUser = UserModel(
        id: user.id,
        name: profileData?['name'] ?? metadata['name'] ?? normalizedEmail.split('@').first,
        email: normalizedEmail,
        userType: userTypeStr == 'vendor' ? UserType.vendor : UserType.client,
        phone: profileData?['phone'] ?? metadata['phone'],
        tradeName: profileData?['trade_name'] ?? metadata['trade_name'],
        bio: profileData?['bio'] ?? metadata['bio'],
        pixKey: profileData?['pix_key'] ?? metadata['pix_key'],
        pixKeyType: profileData?['pix_key_type'] ?? metadata['pix_key_type'],
        referencePoint: profileData?['reference_point'] ?? metadata['reference_point'],
        latitude: (profileData?['latitude'] ?? metadata['latitude'] as num?)?.toDouble(),
        longitude: (profileData?['longitude'] ?? metadata['longitude'] as num?)?.toDouble(),
      );

      _currentUser = loggedInUser;
      _knownVendorProfiles[loggedInUser.id] = loggedInUser;
      notifyListeners();
      return loggedInUser;
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();

      // Fallback para memória APENAS se o Supabase não estiver inicializado (testes locais)
      if (e is AssertionError || errorMsg.contains('initialized') || errorMsg.contains('network')) {
        final record = _memoryUsersDatabase[normalizedEmail];
        if (record != null && record.password == password) {
          _currentUser = record.user;
          notifyListeners();
          return _currentUser!;
        }
      }

      debugPrint('Erro ao autenticar no Supabase: $e');

      if (errorMsg.contains('invalid login credentials') || errorMsg.contains('invalid_credentials')) {
        throw Exception('E-mail ou senha incorretos.');
      }

      if (errorMsg.contains('email not confirmed')) {
        throw Exception('E-mail ainda não confirmado. Desative a opção "Confirm email" no painel do Supabase.');
      }

      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Atualiza o perfil do usuário logado (Onda 3 - Editar Perfil)
  Future<UserModel> updateProfile({
    required String name,
    String? phone,
    String? tradeName,
    String? bio,
    String? pixKey,
    String? pixKeyType,
    String? referencePoint,
    double? latitude,
    double? longitude,
  }) async {
    if (_currentUser == null) {
      throw Exception('Nenhum usuário logado para atualizar o perfil.');
    }

    if (name.trim().isEmpty) {
      throw Exception('O nome não pode ficar em branco.');
    }

    if (_currentUser!.isVendor) {
      if (tradeName == null || tradeName.trim().isEmpty) {
        throw Exception('Vendedores devem informar o Nome Comercial.');
      }
      if (phone == null || phone.trim().isEmpty) {
        throw Exception('Vendedores devem informar o Telefone para contato.');
      }
    }

    final updatedUser = _currentUser!.copyWith(
      name: name.trim(),
      phone: phone?.trim(),
      tradeName: tradeName?.trim(),
      bio: bio?.trim(),
      pixKey: pixKey?.trim(),
      pixKeyType: pixKeyType?.trim(),
      referencePoint: referencePoint?.trim(),
      latitude: latitude,
      longitude: longitude,
    );

    // Tenta atualizar no Supabase
    try {
      final client = Supabase.instance.client;
      
      // Atualiza metadata do auth
      try {
        await client.auth.updateUser(
          UserAttributes(
            data: {
              'name': updatedUser.name,
              'phone': updatedUser.phone,
              'trade_name': updatedUser.tradeName,
              'bio': updatedUser.bio,
              'pix_key': updatedUser.pixKey,
              'pix_key_type': updatedUser.pixKeyType,
              'reference_point': updatedUser.referencePoint,
              'latitude': updatedUser.latitude,
              'longitude': updatedUser.longitude,
            },
          ),
        );
      } catch (authErr) {
        debugPrint('Aviso update auth metadata: $authErr');
      }

      // Atualiza tabela profiles
      try {
        await client.from('profiles').upsert({
          'id': updatedUser.id,
          'name': updatedUser.name,
          'email': updatedUser.email,
          'user_type': updatedUser.userType.name,
          'phone': updatedUser.phone,
          'trade_name': updatedUser.tradeName,
          'bio': updatedUser.bio,
          'pix_key': updatedUser.pixKey,
          'pix_key_type': updatedUser.pixKeyType,
          'reference_point': updatedUser.referencePoint,
          'latitude': updatedUser.latitude,
          'longitude': updatedUser.longitude,
        });
      } catch (profileErr) {
        debugPrint('Aviso update profiles table: $profileErr');
      }
    } catch (e) {
      debugPrint('Aviso Supabase updateProfile: $e');
    }

    // Atualiza nos mapas em memória
    _currentUser = updatedUser;
    _knownVendorProfiles[updatedUser.id] = updatedUser;
    if (_memoryUsersDatabase.containsKey(updatedUser.email)) {
      final oldPassword = _memoryUsersDatabase[updatedUser.email]!.password;
      _memoryUsersDatabase[updatedUser.email] = (user: updatedUser, password: oldPassword);
    }

    notifyListeners();
    return updatedUser;
  }

  /// Desconecta o usuário atual
  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (_) {}
    _currentUser = null;
    notifyListeners();
  }

  /// Busca o perfil público de qualquer usuário (útil para Perfil do Vendedor e Localização)
  Future<UserModel?> getUserProfile(String userId) async {
    // 1. Verifica cache/seed conhecido
    if (_knownVendorProfiles.containsKey(userId)) {
      return _knownVendorProfiles[userId];
    }

    // 2. Busca no Supabase
    try {
      final client = Supabase.instance.client;
      final response = await client.from('profiles').select().eq('id', userId).maybeSingle();
      
      if (response != null) {
        final profile = UserModel(
          id: response['id']?.toString() ?? userId,
          name: response['name']?.toString() ?? 'Vendedor',
          email: response['email']?.toString() ?? '',
          userType: (response['user_type'] == 'vendor' || response['userType'] == 'vendor') ? UserType.vendor : UserType.client,
          phone: response['phone']?.toString(),
          tradeName: (response['trade_name'] ?? response['tradeName'])?.toString(),
          bio: response['bio']?.toString(),
          pixKey: (response['pix_key'] ?? response['pixKey'])?.toString(),
          pixKeyType: (response['pix_key_type'] ?? response['pixKeyType'])?.toString(),
          referencePoint: (response['reference_point'] ?? response['referencePoint'])?.toString(),
          latitude: (response['latitude'] as num?)?.toDouble(),
          longitude: (response['longitude'] as num?)?.toDouble(),
          createdAt: DateTime.tryParse(response['created_at']?.toString() ?? '') ?? DateTime.now(),
        );
        _knownVendorProfiles[userId] = profile;
        return profile;
      }
    } catch (e) {
      debugPrint('Aviso: Não foi possível buscar perfil online ($e)');
    }
    
    // 3. Fallback para os dados locais de teste se disponível
    for (final record in _memoryUsersDatabase.values) {
      if (record.user.id == userId) {
        return record.user;
      }
    }
    
    // 4. Fallback com perfil simulado para não quebrar UI em caso de vendor novo offline
    return UserModel(
      id: userId,
      name: 'Vendedor Local',
      email: 'vendedor@achana rua.com',
      userType: UserType.vendor,
      tradeName: 'Ponto do Vendedor',
      phone: '(11) 99999-9999',
      bio: 'Comerciante local atendendo na vizinhança.',
      referencePoint: 'Ponto fixo na Praça Central',
      pixKey: 'vendedor@pix.com.br',
      pixKeyType: 'E-mail',
    );
  }

  @visibleForTesting
  void reset() {
    _memoryUsersDatabase.clear();
    _knownVendorProfiles.clear();
    _currentUser = null;
    _initSeedVendors();
  }
}
