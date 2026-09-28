import 'package:flutter_test/flutter_test.dart';
import 'package:pa2/features/auth/models/user_model.dart';
import 'package:pa2/features/auth/services/auth_service.dart';

void main() {
  late AuthService authService;

  setUp(() {
    authService = AuthService();
    authService.reset();
  });

  group('AuthService - Criação de Conta / Cadastro', () {
    test('deve registrar um Cliente com sucesso', () async {
      final user = await authService.register(
        name: 'Josué Silva',
        email: 'josue@email.com',
        password: 'senhaSegura123',
        userType: UserType.client,
      );

      expect(user.id, isNotEmpty);
      expect(user.name, 'Josué Silva');
      expect(user.email, 'josue@email.com');
      expect(user.userType, UserType.client);
      expect(user.isClient, isTrue);
      expect(user.isVendor, isFalse);
      expect(authService.currentUser, equals(user));
      expect(authService.isAuthenticated, isTrue);
    });

    test('deve registrar um Vendedor com sucesso preenchendo ponto e telefone', () async {
      final user = await authService.register(
        name: 'Kátia Alencar',
        email: 'katia@tapioca.com',
        password: 'senhaForte123',
        userType: UserType.vendor,
        tradeName: 'Tapioca da Kátia',
        phone: '11999998888',
        bio: 'Tapiocas doces e salgadas feitas na hora na praça.',
      );

      expect(user.name, 'Kátia Alencar');
      expect(user.tradeName, 'Tapioca da Kátia');
      expect(user.phone, '11999998888');
      expect(user.userType, UserType.vendor);
      expect(user.isVendor, isTrue);
    });

    test('deve falhar ao cadastrar Vendedor sem nome comercial do ponto', () async {
      expect(
        () async => await authService.register(
          name: 'Renato Pastel',
          email: 'renato@pastel.com',
          password: 'senhaForte123',
          userType: UserType.vendor,
          tradeName: '', // Vazio
          phone: '11988887777',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('deve falhar com senha menor que 6 caracteres', () async {
      expect(
        () async => await authService.register(
          name: 'Marta Teste',
          email: 'marta@email.com',
          password: '123',
          userType: UserType.client,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('deve falhar ao tentar registrar e-mail duplicado', () async {
      await authService.register(
        name: 'Primeiro Usuário',
        email: 'duplicado@email.com',
        password: 'senha123456',
        userType: UserType.client,
      );

      expect(
        () async => await authService.register(
          name: 'Segundo Usuário',
          email: 'duplicado@email.com',
          password: 'senha654321',
          userType: UserType.client,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
