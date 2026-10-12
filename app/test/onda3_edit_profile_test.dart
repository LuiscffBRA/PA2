import 'package:flutter_test/flutter_test.dart';
import 'package:pa2/features/auth/models/user_model.dart';
import 'package:pa2/features/auth/services/auth_service.dart';

void main() {
  group('Onda 3 - Editar Perfil & Dados de Localização e PIX', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
      authService.reset();
    });

    test('UserModel deve conter campos pixKey, pixKeyType e referencePoint', () {
      final user = UserModel(
        id: 'u_1',
        name: 'Kátia da Silva',
        email: 'katia@lanches.com',
        userType: UserType.vendor,
        phone: '11987654321',
        tradeName: 'Kátia da Esquina',
        pixKey: '11987654321',
        pixKeyType: 'Telefone',
        referencePoint: 'Em frente ao portão 2 da Universidade',
      );

      final json = user.toJson();
      expect(json['pixKey'], equals('11987654321'));
      expect(json['pixKeyType'], equals('Telefone'));
      expect(json['referencePoint'], equals('Em frente ao portão 2 da Universidade'));

      final fromJson = UserModel.fromJson(json);
      expect(fromJson.pixKey, equals('11987654321'));
      expect(fromJson.pixKeyType, equals('Telefone'));
      expect(fromJson.referencePoint, equals('Em frente ao portão 2 da Universidade'));
    });

    test('AuthService.updateProfile atualiza os dados do usuário autenticado', () async {
      // Registra usuário
      await authService.register(
        name: 'Vendedor Teste',
        email: 'vendedor@edit.com',
        password: 'password123',
        userType: UserType.vendor,
        tradeName: 'Ponto Inicial',
        phone: '11900001111',
      );

      expect(authService.currentUser?.name, equals('Vendedor Teste'));

      // Atualiza perfil com dados da Onda 3
      final updated = await authService.updateProfile(
        name: 'Vendedor Teste Atualizado',
        phone: '11999998888',
        tradeName: 'Ponto do Pastel Gourmet',
        bio: 'Novo cardápio disponível!',
        pixKey: '11999998888',
        pixKeyType: 'Telefone',
        referencePoint: 'Praça Central ao lado do Coreto',
      );

      expect(updated.name, equals('Vendedor Teste Atualizado'));
      expect(updated.tradeName, equals('Ponto do Pastel Gourmet'));
      expect(updated.pixKey, equals('11999998888'));
      expect(updated.referencePoint, equals('Praça Central ao lado do Coreto'));
      expect(authService.currentUser?.tradeName, equals('Ponto do Pastel Gourmet'));
    });
  });
}
