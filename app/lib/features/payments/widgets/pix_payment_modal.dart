import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pa2/core/theme/app_theme.dart';
import 'package:pa2/core/utils/pix_helper.dart';

class PixPaymentModal extends StatefulWidget {
  final String pixKey;
  final String? pixKeyType;
  final String merchantName;
  final String merchantTradeName;
  final double amount;
  final String itemTitle;

  const PixPaymentModal({
    super.key,
    required this.pixKey,
    this.pixKeyType,
    required this.merchantName,
    required this.merchantTradeName,
    required this.amount,
    required this.itemTitle,
  });

  @override
  State<PixPaymentModal> createState() => _PixPaymentModalState();
}

class _PixPaymentModalState extends State<PixPaymentModal> {
  late String _selectedType;

  final List<String> _keyTypes = ['Telefone', 'CPF', 'CNPJ', 'E-mail', 'Chave Aleatória'];

  @override
  void initState() {
    super.initState();
    _selectedType = (widget.pixKeyType != null && _keyTypes.contains(widget.pixKeyType))
        ? widget.pixKeyType!
        : _detectType(widget.pixKey);
  }

  String _detectType(String key) {
    if (key.contains('@')) return 'E-mail';
    final digits = key.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 14) return 'CNPJ';
    if (key.startsWith('+') || key.contains('(')) return 'Telefone';
    if (digits.length == 11 && !key.startsWith('+')) return 'CPF';
    if (key.length > 20) return 'Chave Aleatória';
    return 'Telefone';
  }

  @override
  Widget build(BuildContext context) {
    final effectivePixKey = widget.pixKey.trim();
    final formattedBacenKey = PixHelper.formatPixKey(effectivePixKey, _selectedType);

    final pixPayload = PixHelper.generatePixPayload(
      pixKey: effectivePixKey,
      pixKeyType: _selectedType,
      merchantName: widget.merchantTradeName.isNotEmpty ? widget.merchantTradeName : widget.merchantName,
      merchantCity: 'SAO PAULO',
      amount: widget.amount,
      description: widget.itemTitle,
    );

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Barra superior de arraste
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Cabeçalho
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.qr_code_2, color: Colors.teal, size: 28),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Pagamento via PIX',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Pague instantaneamente para ${widget.merchantTradeName}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),

            // Card de Resumo do Pedido e Valor
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryLight),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.itemTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Beneficiário: ${widget.merchantName}',
                          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'R\$ ${widget.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Renderização do QR Code PIX
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: QrImageView(
                data: pixPayload.isNotEmpty ? pixPayload : effectivePixKey,
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            // Informação da Chave Pix Formatada
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.key, size: 16, color: Colors.teal),
                      const SizedBox(width: 6),
                      Text(
                        'Chave $_selectedType: $formattedBacenKey',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Botão Copiar Código PIX (Copia e Cola)
            ElevatedButton.icon(
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('Copiar Código PIX (Copia e Cola)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: pixPayload.isNotEmpty ? pixPayload : effectivePixKey));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Código PIX copiado para a área de transferência!'),
                      ],
                    ),
                    backgroundColor: Colors.teal,
                    duration: Duration(seconds: 3),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),

            // Botão Copiar apenas a Chave
            OutlinedButton.icon(
              icon: const Icon(Icons.copy_outlined, size: 18),
              label: const Text('Copiar apenas a Chave PIX'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: formattedBacenKey));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Chave PIX copiada: $formattedBacenKey'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Dica e Segurança
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Importante: Se aparecer "Chave não localizada" no app do banco, verifique se a chave é real e se o tipo selecionado (Telefone com DDD, CPF sem pontuação ou E-mail) é exatamente o mesmo cadastrado no seu banco.',
                      style: TextStyle(fontSize: 12, color: Colors.brown),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
