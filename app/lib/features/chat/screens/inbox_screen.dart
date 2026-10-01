import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pa2/core/theme/app_theme.dart';
import 'package:pa2/features/auth/services/auth_service.dart';
import 'package:pa2/features/chat/screens/chat_screen.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final _client = Supabase.instance.client;
  String _currentUserId = '';
  List<Map<String, dynamic>> _conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentUserId = AuthService().currentUser?.id ?? '';
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    if (_currentUserId.isEmpty) return;

    try {
      // Busca as mensagens onde eu sou remetente ou destinatário
      final response = await _client
          .from('chat_messages')
          .select('''
            *,
            sender:profiles!chat_messages_sender_id_fkey(id, name, trade_name),
            receiver:profiles!chat_messages_receiver_id_fkey(id, name, trade_name)
          ''')
          .or('sender_id.eq.$_currentUserId,receiver_id.eq.$_currentUserId')
          .order('created_at', ascending: false);

      // Agrupa localmente para pegar apenas a última mensagem por usuário
      final Map<String, Map<String, dynamic>> grouped = {};

      for (var row in response as List<dynamic>) {
        final isMeSender = row['sender_id'] == _currentUserId;
        final otherUserId = isMeSender ? row['receiver_id'] : row['sender_id'];
        final otherUserData = isMeSender ? row['receiver'] : row['sender'];

        if (!grouped.containsKey(otherUserId)) {
          grouped[otherUserId] = {
            'otherUserId': otherUserId,
            'otherUserName': otherUserData?['trade_name'] ?? otherUserData?['name'] ?? 'Usuário',
            'lastMessage': row['content'],
            'createdAt': DateTime.parse(row['created_at']),
            'isUnread': !isMeSender, // Uma lógica simples
          };
        }
      }

      if (mounted) {
        setState(() {
          _conversations = grouped.values.toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar inbox: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Conversas'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _conversations.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhuma conversa encontrada.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView.separated(
                  itemCount: _conversations.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final chat = _conversations[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primaryLight,
                        child: Text(
                          chat['otherUserName'].toString()[0].toUpperCase(),
                          style: const TextStyle(
                            color: AppTheme.primaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        chat['otherUserName'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        chat['lastMessage'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              otherUserId: chat['otherUserId'],
                              otherUserName: chat['otherUserName'],
                            ),
                          ),
                        ).then((_) => _loadConversations()); // Recarrega ao voltar
                      },
                    );
                  },
                ),
    );
  }
}
