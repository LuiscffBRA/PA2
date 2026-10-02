import 'package:flutter/material.dart';
import 'package:pa2/core/theme/app_theme.dart';
import 'package:pa2/features/feed/services/feed_service.dart';
import 'package:pa2/features/feed/widgets/post_card_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _feedService = FeedService();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final searchResults = _searchQuery.isEmpty 
        ? [] 
        : _feedService.searchPosts(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: AppTheme.primaryColor,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: TextField(
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'O que você quer comer hoje?',
                prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchQuery.isEmpty
                ? const Center(
                    child: Text(
                      'Busque por lanches, pontos ou vendedores...',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : searchResults.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum resultado encontrado.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return PostCardWidget(post: searchResults[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
