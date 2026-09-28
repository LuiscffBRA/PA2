import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pa2/core/theme/app_theme.dart';
import 'package:pa2/features/auth/services/auth_service.dart';
import '../models/food_catalog.dart';
import '../services/feed_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  final _feedService = FeedService();
  final _authService = AuthService();
  final _imagePicker = ImagePicker();

  FoodCategory? _selectedCategory;
  FoodItemSuggestion? _selectedSuggestion;

  // Imagem: pode ser da galeria/câmera (local) ou do catálogo (web)
  String? _selectedImageUrl;
  XFile? _pickedImageFile;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(FoodCategory? category) {
    setState(() {
      _selectedCategory = category;
      _selectedSuggestion = null;
    });
  }

  void _onSuggestionSelected(FoodItemSuggestion suggestion) {
    setState(() {
      _selectedSuggestion = suggestion;
      _titleController.text = suggestion.name;
      _descriptionController.text = suggestion.defaultDescription;
      _priceController.text = suggestion.suggestedPrice.toStringAsFixed(2);
      _selectedImageUrl = suggestion.imageUrl;
      _pickedImageFile = null; // Prioriza a foto da sugestão escolhida
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (picked != null) {
        setState(() {
          _pickedImageFile = picked;
          _selectedImageUrl = picked.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível obter a imagem: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Escolher foto do produto',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.photo_camera_rounded, color: AppTheme.primaryColor),
                  title: const Text('Tirar foto com a câmera'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_rounded, color: AppTheme.primaryColor),
                  title: const Text('Escolher da galeria do celular'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handlePublish() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _authService.currentUser;
    if (user == null || !user.isVendor) {
      setState(() {
        _errorMessage = 'Apenas vendedores autenticados podem publicar produtos.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final priceClean = _priceController.text.replaceAll(',', '.').trim();
      final price = double.tryParse(priceClean) ?? 0.0;

      await _feedService.createPost(
        vendor: user,
        title: _titleController.text,
        description: _descriptionController.text,
        price: price,
        imageUrl: _selectedImageUrl,
        category: _selectedCategory?.name,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produto publicado com sucesso no feed!'),
            backgroundColor: AppTheme.secondaryColor,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildImagePreview() {
    if (_pickedImageFile != null && !kIsWeb) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.file(
          File(_pickedImageFile!.path),
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } else if (_selectedImageUrl != null && _selectedImageUrl!.isNotEmpty) {
      if (_selectedImageUrl!.startsWith('assets/')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            _selectedImageUrl!,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildPlaceholder(),
          ),
        );
      }
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          _selectedImageUrl!,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, size: 36, color: Colors.grey.shade600),
            const SizedBox(height: 8),
            Text(
              'Toque para tirar foto ou escolher da galeria\nou selecione uma categoria abaixo',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Postagem'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Preview da Imagem com Botão de Ação
              InkWell(
                onTap: _showImageSourceDialog,
                borderRadius: BorderRadius.circular(14),
                child: _buildImagePreview(),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: _showImageSourceDialog,
                    icon: const Icon(Icons.camera_alt_outlined, size: 18),
                    label: const Text('Tirar Foto / Galeria'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Seletor de Categoria estilo iFood
              const Text(
                '1. Categoria do Produto',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<FoodCategory>(
                value: _selectedCategory,
                isExpanded: true,
                decoration: const InputDecoration(
                  hintText: 'Selecione a categoria...',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: FoodCatalog.categories.map((cat) {
                  return DropdownMenuItem<FoodCategory>(
                    value: cat,
                    child: Text(
                      '${cat.icon}  ${cat.name}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: _onCategoryChanged,
              ),

              // Seletor de Comidas Sugeridas da Categoria
              if (_selectedCategory != null) ...[
                const SizedBox(height: 16),
                Text(
                  '2. Sugestão rápida de ${_selectedCategory!.name}:',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 110,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedCategory!.suggestions.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final item = _selectedCategory!.suggestions[index];
                      final isSelected = _selectedSuggestion == item;

                      return InkWell(
                        onTap: () => _onSuggestionSelected(item),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 130,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryLight.withOpacity(0.5) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: item.imageUrl.startsWith('assets/')
                                    ? Image.asset(
                                        item.imageUrl,
                                        height: 48,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Icon(Icons.fastfood, size: 30),
                                      )
                                    : Image.network(
                                        item.imageUrl,
                                        height: 48,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Icon(Icons.fastfood, size: 30),
                                      ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),

              const Text(
                '3. Detalhes da Postagem',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade800, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Título / Nome do Produto
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Lanche / Produto *',
                  hintText: 'Ex: Pizza Brotinho de Calabresa',
                  prefixIcon: Icon(Icons.fastfood_outlined),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Informe o nome do produto.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Preço
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Preço (R\$) *',
                  hintText: 'Ex: 18,00',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Informe o valor do produto.';
                  }
                  final parsed = double.tryParse(val.replaceAll(',', '.'));
                  if (parsed == null || parsed <= 0) {
                    return 'Informe um preço válido maior que zero.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Descrição
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descrição detalhada *',
                  hintText: 'Ex: Molho caseiro, calabresa crocante e queijo derretido.',
                  prefixIcon: Icon(Icons.notes_rounded),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Conte aos clientes o que seu produto tem de especial.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Botão Publicar
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _handlePublish,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.campaign_rounded),
                label: Text(
                  _isLoading ? 'Publicando...' : 'Publicar no Feed',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
