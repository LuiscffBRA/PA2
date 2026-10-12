import 'package:flutter_test/flutter_test.dart';
import 'package:pa2/features/auth/services/auth_service.dart';

void main() {
  group('AuthService - Buscar Perfil (Onda 2 & 3)', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
      authService.reset();
    });

    test('Deve retornar o perfil de vendedor seed conhecido', () async {
      final profile = await authService.getUserProfile('v_1');
      expect(profile, isNotNull);
      expect(profile!.name, equals('Kátia da Silva'));
      expect(profile.tradeName, equals('Kátia da Esquina - Salgados'));
      expect(profile.pixKey, equals('11987654321'));
      expect(profile.referencePoint, contains('Em frente ao portão principal'));
    });

    test('Deve retornar um perfil fallback caso o ID seja inexistente', () async {
      final profile = await authService.getUserProfile('id_que_nao_existe');
      expect(profile, isNotNull);
      expect(profile!.name, isNotEmpty);
    });
  });
}
