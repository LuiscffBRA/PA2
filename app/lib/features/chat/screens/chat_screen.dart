import 'package:flutter/material.dart';
import 'package:pa2/core/theme/app_theme.dart';
import 'package:pa2/features/auth/services/auth_service.dart';
import 'package:pa2/features/chat/models/chat_message_model.dart';
import 'package:pa2/features/chat/services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String otherUserId;
  final String otherUserName;

  const ChatScreen({
    super.key,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _chatService = ChatService();
  final _scrollController = ScrollController();
  late final String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = AuthService().currentUser?.id ?? '';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final content = _messageController.text;
    if (content.trim().isEmpty || _currentUserId.isEmpty) return;

    _messageController.clear();
    
    try {
      await _chatService.sendMessage(_currentUserId, widget.otherUserId, content);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao enviar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: const Center(child: Text('Você precisa estar logado para usar o chat.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUserName),
        backgroundColor: AppTheme.primaryColor,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessageModel>>(
              stream: _chatService.getMessagesStream(_currentUserId, widget.otherUserId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;
                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nenhuma mensagem ainda. Diga olá!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                // Pequeno delay para scrollar pro final quando carregar/chegar nova
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == _currentUserId;
                    
                    final timeString = "${msg.createdAt.toLocal().hour.toString().padLeft(2, '0')}:${msg.createdAt.toLocal().minute.toString().padLeft(2, '0')}";
                    final initial = isMe ? 'V' : widget.otherUserName.isNotEmpty ? widget.otherUserName[0].toUpperCase() : 'U';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isMe)
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppTheme.primaryLight,
                              child: Text(initial, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryDark)),
                            ),
                          if (!isMe) const SizedBox(width: 8),
                          
                          Flexible(
                            child: Column(
                              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isMe ? 'Você' : widget.otherUserName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isMe ? AppTheme.primaryColor : Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isMe ? AppTheme.primaryColor : Colors.grey.shade200,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(16),
                                      topRight: const Radius.circular(16),
                                      bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                                      bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    msg.content,
                                    style: TextStyle(
                                      color: isMe ? Colors.white : AppTheme.textPrimary,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  timeString,
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          
                          if (isMe) const SizedBox(width: 8),
                          if (isMe)
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppTheme.primaryColor,
                              child: const Icon(Icons.person, size: 18, color: Colors.white),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          // Campo de digitação
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Digite uma mensagem...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppTheme.primaryColor,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
