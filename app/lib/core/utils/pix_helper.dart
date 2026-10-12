import 'dart:convert';

/// Utilitário oficial de geração de códigos PIX no padrão BR Code / EMV do Banco Central do Brasil (BACEN)
class PixHelper {
  /// Higieniza e padroniza a chave PIX de acordo com as regras oficiais do BACEN
  static String formatPixKey(String rawKey, [String? keyType]) {
    final clean = rawKey.trim();
    if (clean.isEmpty) return '';

    final type = (keyType ?? '').toLowerCase().trim();

    // 1. CPF (exige exatamente 11 dígitos numéricos limpos)
    if (type == 'cpf') {
      return clean.replaceAll(RegExp(r'\D'), '');
    }

    // 2. CNPJ (exige exatamente 14 dígitos numéricos limpos)
    if (type == 'cnpj') {
      return clean.replaceAll(RegExp(r'\D'), '');
    }

    // 3. Telefone (BACEN exige formato internacional E.164: +55DDD9XXXXXXXX)
    if (type.contains('tel') || type.contains('fone') || type.contains('celular')) {
      final digits = clean.replaceAll(RegExp(r'\D'), '');
      if (digits.startsWith('55') && digits.length >= 12) {
        return '+$digits';
      }
      if (clean.startsWith('+')) return clean;
      return '+55$digits';
    }

    // 4. E-mail (minúsculo e sem espaços)
    if (type.contains('mail')) {
      return clean.toLowerCase();
    }

    // 5. Chave Aleatória (EVP)
    if (type.contains('aleat') || type.contains('evp') || type.contains('chave')) {
      return clean.trim();
    }

    // -------------------------------------------------------------
    // Detecção Automática caso keyType não seja informado
    // -------------------------------------------------------------

    // E-mail
    if (clean.contains('@')) {
      return clean.toLowerCase();
    }

    // Chave Aleatória UUID (ex: 123e4567-e89b-12d3-a456-426614174000)
    final uuidRegex = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');
    if (uuidRegex.hasMatch(clean)) {
      return clean.trim();
    }

    final digits = clean.replaceAll(RegExp(r'\D'), '');

    // CNPJ (14 dígitos)
    if (digits.length == 14) {
      return digits;
    }

    // Telefone explicitamente com código do país ou parênteses de DDD
    if (clean.startsWith('+55') || clean.startsWith('+') || (clean.contains('(') && clean.contains(')'))) {
      if (digits.startsWith('55') && digits.length >= 12) {
        return '+$digits';
      }
      return '+55$digits';
    }

    // CPF (11 dígitos formatados com pontos)
    if (clean.contains('.') && digits.length == 11) {
      return digits;
    }

    // 11 dígitos puros: se começar com DDD + 9 (telefone móvel típico), pode ser telefone ou CPF.
    return clean;
  }

  /// Gera a string do Pix Copia e Cola formatada conforme o padrão EMV / BACEN
  static String generatePixPayload({
    required String pixKey,
    required String merchantName,
    String? merchantTradeName,
    String merchantCity = 'SAO PAULO',
    required double amount,
    String txId = '***',
    String? description,
    String? itemTitle,
    String? pixKeyType,
  }) {
    final formattedKey = formatPixKey(pixKey, pixKeyType);
    if (formattedKey.isEmpty) {
      return '';
    }

    final effectiveDescription = description ?? itemTitle;

    // Prioriza o nome do titular ou do estabelecimento comercial
    final effectiveName = (merchantTradeName != null && merchantTradeName.trim().isNotEmpty)
        ? merchantTradeName.trim()
        : merchantName.trim();

    // Formata o valor com duas casas decimais
    final amountFormatted = amount > 0 ? amount.toStringAsFixed(2) : '0.00';

    // Higieniza strings (apenas caracteres seguros sem acentos)
    final sanitizedName = _sanitizeString(effectiveName, 25);
    final sanitizedCity = _sanitizeString(merchantCity, 15);
    final sanitizedTxId = _sanitizeString(txId, 25);

    // Sub-blocos da conta do recebedor (Tag 26)
    // 00: GUI (br.gov.bcb.pix)
    // 01: Chave PIX
    // 02: Descrição (opcional)
    final guiBlock = _formatTlv('00', 'br.gov.bcb.pix');
    final keyBlock = _formatTlv('01', formattedKey);
    final descBlock = effectiveDescription != null && effectiveDescription.isNotEmpty
        ? _formatTlv('02', _sanitizeString(effectiveDescription, 50))
        : '';
    final merchantAccountInfo = _formatTlv('26', '$guiBlock$keyBlock$descBlock');

    // Constrói os campos EMV principais no padrão oficial do Banco Central
    final payloadWithoutCrc = [
      _formatTlv('00', '01'), // Payload Format Indicator ('01')
      _formatTlv('01', '11'), // Point of Initiation: '11' (QR Code Estático)
      merchantAccountInfo,    // Merchant Account Info
      _formatTlv('52', '0000'), // Merchant Category Code (0000 = Geral)
      _formatTlv('53', '986'),  // Transaction Currency (986 = BRL)
      if (amount > 0) _formatTlv('54', amountFormatted), // Transaction Amount
      _formatTlv('58', 'BR'),   // Country Code (BR)
      _formatTlv('59', sanitizedName.isEmpty ? 'RECEBEDOR' : sanitizedName), // Merchant Name
      _formatTlv('60', sanitizedCity.isEmpty ? 'SAO PAULO' : sanitizedCity), // Merchant City
      _formatTlv('62', _formatTlv('05', sanitizedTxId.isEmpty ? '***' : sanitizedTxId)), // Additional Data: txid
      '6304', // CRC16 ID e tamanho fixo
    ].join();

    final crc = _calculateCrc16(payloadWithoutCrc);
    return '$payloadWithoutCrc$crc';
  }

  /// Formata uma tag no padrão TLV (Tag-Length-Value)
  static String _formatTlv(String tag, String value) {
    final length = utf8.encode(value).length.toString().padLeft(2, '0');
    return '$tag$length$value';
  }

  /// Calcula o checksum CRC16-CCITT (Polinômio 0x1021, Inicial 0xFFFF)
  static String _calculateCrc16(String input) {
    int crc = 0xFFFF;
    final bytes = utf8.encode(input);

    for (final byte in bytes) {
      crc ^= (byte << 8);
      for (int i = 0; i < 8; i++) {
        if ((crc & 0x8000) != 0) {
          crc = ((crc << 1) ^ 0x1021) & 0xFFFF;
        } else {
          crc = (crc << 1) & 0xFFFF;
        }
      }
    }

    return crc.toRadixString(16).toUpperCase().padLeft(4, '0');
  }

  /// Higieniza strings para o padrão do BACEN (apenas alfanuméricos e sem acentos)
  static String _sanitizeString(String input, int maxLength) {
    var clean = input
        .replaceAll(RegExp(r'[áàâãä]'), 'a')
        .replaceAll(RegExp(r'[ÁÀÂÃÄ]'), 'A')
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[ÉÈÊË]'), 'E')
        .replaceAll(RegExp(r'[íìîï]'), 'i')
        .replaceAll(RegExp(r'[ÍÌÎÏ]'), 'I')
        .replaceAll(RegExp(r'[óòôõö]'), 'o')
        .replaceAll(RegExp(r'[ÓÒÔÕÖ]'), 'O')
        .replaceAll(RegExp(r'[úùûü]'), 'u')
        .replaceAll(RegExp(r'[ÚÙÛÜ]'), 'U')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .replaceAll(RegExp(r'[Ç]'), 'C')
        .replaceAll(RegExp(r'[^a-zA-Z0-9\s-]'), '')
        .trim();

    if (clean.length > maxLength) {
      clean = clean.substring(0, maxLength);
    }
    return clean;
  }
}
