import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pa2/core/theme/app_theme.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../services/feed_service.dart';
import 'comments_modal.dart';
import 'package:pa2/features/auth/services/auth_service.dart';
import 'package:pa2/features/profile/screens/vendor_profile_screen.dart';
import 'package:pa2/features/chat/screens/chat_screen.dart';
import 'package:pa2/features/payments/widgets/pix_payment_modal.dart';

class PostDetailsModal extends StatefulWidget {
  final PostModel post;

  const PostDetailsModal({super.key, required this.post});

  @override
  State<PostDetailsModal> createState() => _PostDetailsModalState();
}

class _PostDetailsModalState extends State<PostDetailsModal> {
  final _feedService = FeedService();
  final _authService = AuthService();
  final _quickCommentController = TextEditingController();

  List<CommentModel> _comments = [];
  bool _isLoadingComments = true;
  bool _isSendingComment = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _quickCommentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    final list = await _feedService.fetchComments(widget.post.id);
    if (mounted) {
      setState(() {
        _comments = list;
        _isLoadingComments = false;
      });
    }
  }

  Future<void> _sendQuickComment() async {
    final text = _quickCommentController.text.trim();
    if (text.isEmpty) return;

    final user = _authService.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faça login para comentar!')),
      );
      return;
    }

    setState(() => _isSendingComment = true);
    try {
      final comment = await _feedService.addComment(
        postId: widget.post.id,
        user: user,
        content: text,
      );
      _quickCommentController.clear();
      if (mounted) {
        setState(() {
          _comments.add(comment);
          _isSendingComment = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSendingComment = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao comentar: $e')),
        );
      }
    }
  }

  Future<void> _openGoogleMaps(String locationQuery) async {
    final query = locationQuery.trim();
    if (query.isEmpty) return;

    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');
    try {
      final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        await launchUrl(url, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível abrir o mapa: $e')),
        );
      }
    }
  }

  void _openPixModal() async {
    final post = widget.post;
    final vendorProfile = await _authService.getUserProfile(post.vendorId);
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

    if (!mounted) return;

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
    final post = widget.post;
    final locationText = (post.vendorReferencePoint != null && post.vendorReferencePoint!.isNotEmpty)
        ? post.vendorReferencePoint!
        : 'Ponto fixo do vendedor na vizinhança';

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
                            fontSize: 22,
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
                  const SizedBox(height: 14),

                  // Título do Lanche
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

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

                  // BOTÃO PRINCIPAL DE TRANSAÇÃO PIX (Onda 3)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code_2, size: 22),
                    label: Text('Pagar R\$ ${post.price.toStringAsFixed(2)} via PIX'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                    ),
                    onPressed: _openPixModal,
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),

                  // LOCALIZAÇÃO DO VENDEDOR (Onda 3)
                  Card(
                    elevation: 0,
                    color: Colors.blue.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.blue.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.blue.shade800, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Localização & Ponto de Retirada',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            locationText,
                            style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.map_outlined, size: 16),
                            label: const Text('Como Chegar (Google Maps)'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 38),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => _openGoogleMaps(locationText),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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

                  InkWell(
                    onTap: () {
                      Navigator.pop(context); // close modal
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VendorProfileScreen(vendorId: post.vendorId),
                        ),
                      );
                    },
                    child: Row(
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
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chat_outlined, color: AppTheme.primaryColor),
                          tooltip: 'Abrir Chat',
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  otherUserId: post.vendorId,
                                  otherUserName: post.vendorTradeName,
                                ),
                              ),
                            );
                          },
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),

                  // SEÇÃO DE COMENTÁRIOS (Onda 3)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.forum_outlined, size: 18, color: AppTheme.primaryColor),
                          const SizedBox(width: 6),
                          Text(
                            'Comentários & Dúvidas (${_comments.length})',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => CommentsModal(postId: post.id, postTitle: post.title),
                          );
                        },
                        child: const Text('Ver todos'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Comentários Recentes
                  if (_isLoadingComments)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(),
                    ))
                  else if (_comments.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Nenhum comentário ainda. Deixe sua pergunta abaixo!',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: _comments.take(3).map((c) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: c.isVendorAuthor
                                ? AppTheme.primaryLight.withOpacity(0.25)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: c.isVendorAuthor ? AppTheme.primaryColor : Colors.grey.shade300,
                                child: Text(
                                  c.userName.isNotEmpty ? c.userName[0].toUpperCase() : 'U',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: c.isVendorAuthor ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          c.userName,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                        ),
                                        if (c.isVendorAuthor) ...[
                                          const SizedBox(width: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: AppTheme.primaryColor,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text('Vendedor', style: TextStyle(color: Colors.white, fontSize: 8)),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(c.content, style: const TextStyle(fontSize: 13)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 10),

                  // Input rápido de comentário
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _quickCommentController,
                          decoration: InputDecoration(
                            hintText: 'Escreva uma dúvida...',
                            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (_) => _sendQuickComment(),
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: _isSendingComment
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.send, color: AppTheme.primaryColor),
                        onPressed: _isSendingComment ? null : _sendQuickComment,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black87,
                      minimumSize: const Size(double.infinity, 44),
                    ),
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
