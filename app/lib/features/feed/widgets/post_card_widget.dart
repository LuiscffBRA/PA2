import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pa2/core/theme/app_theme.dart';
import '../models/post_model.dart';
import 'post_details_modal.dart';

class PostCardWidget extends StatelessWidget {
  final PostModel post;

  const PostCardWidget({
    super.key,
    required this.post,
  });

  Widget _buildImage(String imageSource) {
    if (imageSource.startsWith('assets/')) {
      return Image.asset(
        imageSource,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    }

    final isLocalFile = !imageSource.startsWith('http://') && !imageSource.startsWith('https://');

    if (isLocalFile && !kIsWeb) {
      final file = File(imageSource);
      if (file.existsSync()) {
        return Image.file(
          file,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallback(),
        );
      }
    }

    return Image.network(
      imageSource,
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildFallback(),
    );
  }

  Widget _buildFallback() {
    return Container(
      height: 160,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.fastfood, size: 48, color: Colors.grey),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PostDetailsModal(post: post),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showDetails(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho do Vendedor
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.primaryLight,
                    child: const Icon(Icons.storefront, color: AppTheme.primaryDark),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.vendorTradeName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Por ${post.vendorName}',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'R\$ ${post.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppTheme.secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Foto do Produto
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              _buildImage(post.imageUrl!),

            // Conteúdo do Post
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          post.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      if (post.category != null && post.category!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            post.category!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryDark,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    post.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.favorite_border, size: 20, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${post.likesCount} curtidas',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            'Toque para detalhes',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios, size: 10, color: AppTheme.primaryColor),
                        ],
                      ),
                    ],
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
