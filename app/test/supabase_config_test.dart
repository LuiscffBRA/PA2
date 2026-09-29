import 'package:flutter_test/flutter_test.dart';
import 'package:pa2/core/config/supabase_config.dart';

void main() {
  group('SupabaseConfig - Testes de Configuração do Backend', () {
    test('URL do Supabase deve estar configurada e ser HTTPS válida', () {
      expect(SupabaseConfig.supabaseUrl, isNotEmpty);
      expect(SupabaseConfig.supabaseUrl.startsWith('https://'), isTrue);
      expect(SupabaseConfig.supabaseUrl.contains('supabase.co'), isTrue);
    });

    test('Chave Anon pública do Supabase deve estar configurada e ser JWT', () {
      expect(SupabaseConfig.supabaseAnonKey, isNotEmpty);
      expect(SupabaseConfig.supabaseAnonKey.split('.').length, equals(3));
    });
  });
}
