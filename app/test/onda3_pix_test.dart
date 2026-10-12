import 'package:flutter_test/flutter_test.dart';
import 'package:pa2/core/utils/pix_helper.dart';

void main() {
  group('Onda 3 - Utilitário PIX (BR Code / EMV)', () {
    test('Gera string de Pix Copia e Cola válida com chave, valor e recebedor', () {
      final payload = PixHelper.generatePixPayload(
        pixKey: '11987654321',
        merchantName: 'Kátia da Silva',
        merchantTradeName: 'Kátia Salgados',
        merchantCity: 'SAO PAULO',
        amount: 9.50,
        itemTitle: 'Pastel de Carne',
      );

      expect(payload, isNotEmpty);
      expect(payload.startsWith('000201'), isTrue); // Indicador padrão EMV
      expect(payload, contains('br.gov.bcb.pix')); // GUI do Pix BACEN
      expect(payload, contains('11987654321')); // Chave Pix do vendedor
      expect(payload, contains('9.50')); // Valor formatado
      expect(payload, contains('6304')); // CRC16 Header
      expect(payload.length, greaterThan(50));
    });

    test('Retorna vazio se a chave PIX estiver em branco', () {
      final payload = PixHelper.generatePixPayload(
        pixKey: '   ',
        merchantName: 'Kátia',
        merchantTradeName: 'Kátia Salgados',
        merchantCity: 'SAO PAULO',
        amount: 10.0,
      );

      expect(payload, isEmpty);
    });

    test('Calcula checksum CRC16 de 4 caracteres hexadecimais no final', () {
      final payload = PixHelper.generatePixPayload(
        pixKey: 'renato@tapioca.com',
        merchantName: 'Renato Silva',
        merchantTradeName: 'Ponto do Renato',
        merchantCity: 'SAO PAULO',
        amount: 15.00,
      );

      // O payload deve terminar com o CRC16 de 4 dígitos hexadecimais
      final crc = payload.substring(payload.length - 4);
      expect(RegExp(r'^[0-9A-F]{4}$').hasMatch(crc), isTrue);
    });
  });
}
