import 'package:flutter_test/flutter_test.dart';
import 'package:pa2/features/auth/services/auth_service.dart';

void main() {
  group('AuthService - Buscar Perfil (Onda 2)', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
      authService.reset();
    });

    test('Deve retornar um perfil fallback caso o ID seja inexistente', () async {
      final profile = await authService.getUserProfile('id_que_nao_existe');
      expect(profile, isNotNull);
      expect(profile!.name, contains('Offline'));
    });
  });
}
