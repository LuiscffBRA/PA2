import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pa2/core/theme/app_theme.dart';
import '../models/post_model.dart';
import 'post_details_modal.dart';
import 'comments_modal.dart';
import 'package:pa2/features/profile/screens/vendor_profile_screen.dart';
import 'package:pa2/features/auth/services/auth_service.dart';
import 'package:pa2/features/payments/widgets/pix_payment_modal.dart';
import '../services/feed_service.dart';

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

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentsModal(postId: post.id, postTitle: post.title),
    );
  }

  void _showPix(BuildContext context) async {
    final vendorProfile = await AuthService().getUserProfile(post.vendorId);
    final effectivePixKey = vendorProfile?.pixKey?.isNotEmpty == true
        ? vendorProfile!.pixKey!
        : (post.vendorPixKey?.isNotEmpty == true
            ? post.vendorPixKey!
            : (vendorProfile?.phone?.isNotEmpty == true
                ? vendorProfile!.phone!
                : (post.vendorPhone ?? '11987654321')));
    final effectivePixKeyType = vendorProfile?.pixKeyType;
    final merchantName = vendorProfile?.name ?? post.vendorName;
    final merchantTradeName = (vendorProfile?.tradeName?.isNotEmpty == true)
        ? vendorProfile!.tradeName!
        : post.vendorTradeName;

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PixPaymentModal(
        pixKey: effectivePixKey,
        pixKeyType: effectivePixKeyType,
        merchantName: merchantName,
        merchantTradeName: merchantTradeName,
        amount: post.price,
        itemTitle: post.title,
      ),
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VendorProfileScreen(vendorId: post.vendorId),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: AppTheme.primaryLight,
                      child: const Icon(Icons.storefront, color: AppTheme.primaryDark),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VendorProfileScreen(vendorId: post.vendorId),
                          ),
                        );
                      },
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
                  const SizedBox(height: 14),

                  // Barra de Interação (Likes, Comentários Onda 3 e Pagamento PIX Onda 3)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Curtidas
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              post.isLikedByMe ? Icons.favorite : Icons.favorite_border,
                              color: post.isLikedByMe ? Colors.red : Colors.grey.shade700,
                              size: 22,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              final authService = AuthService();
                              final currentUser = authService.currentUser;
                              if (currentUser != null) {
                                FeedService().toggleLike(post.id, currentUser.id);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Faça login para curtir!')),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${post.likesCount}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
                          ),
                          const SizedBox(width: 14),

                          // Comentários (Onda 3)
                          IconButton(
                            icon: const Icon(Icons.chat_bubble_outline, size: 20, color: Colors.blueGrey),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => _showComments(context),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${post.commentsCount}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
                          ),
                        ],
                      ),

                      // Botão Rápido PIX (Onda 3)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.qr_code_2, size: 16),
                        label: const Text('Pagar PIX'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          minimumSize: const Size(90, 32),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => _showPix(context),
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
