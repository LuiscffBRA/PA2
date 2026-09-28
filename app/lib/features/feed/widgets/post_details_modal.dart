import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pa2/core/theme/app_theme.dart';
import '../models/post_model.dart';

class PostDetailsModal extends StatelessWidget {
  final PostModel post;

  const PostDetailsModal({super.key, required this.post});

  Widget _buildImage(String imageSource) {
    if (imageSource.startsWith('assets/')) {
      return Image.asset(
        imageSource,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    final isLocalFile = !imageSource.startsWith('http://') && !imageSource.startsWith('https://');

    if (isLocalFile && !kIsWeb) {
      final file = File(imageSource);
      if (file.existsSync()) {
        return Image.file(
          file,
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      }
    }

    return Image.network(
      imageSource,
      height: 250,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        height: 180,
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(Icons.fastfood, size: 54, color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicador de arrastar do modal
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              _buildImage(post.imageUrl!),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preço e Categoria
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'R\$ ${post.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppTheme.secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      if (post.category != null && post.category!.isNotEmpty)
                        Chip(
                          label: Text(post.category!),
                          backgroundColor: AppTheme.primaryLight.withOpacity(0.4),
                          labelStyle: const TextStyle(
                            color: AppTheme.primaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Título do Lanche
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Descrição completa
                  Text(
                    post.description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Dados do Vendedor Ambulante / Ponto
                  const Text(
                    'Informações do Ponto de Venda',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppTheme.primaryLight,
                        child: const Icon(Icons.storefront, color: AppTheme.primaryDark),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.vendorTradeName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Vendedor(a): ${post.vendorName}',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            if (post.vendorPhone != null)
                              Text(
                                'Contato: ${post.vendorPhone}',
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Aviso de retirada (visão Lean Inception)
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
                            'Retirada no ponto de venda. Negocie no chat e pague via PIX na retirada!',
                            style: TextStyle(fontSize: 12, color: Colors.brown),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fechar Detalhes'),
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
