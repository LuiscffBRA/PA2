import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pa2/features/chat/models/chat_message_model.dart';

class ChatService {
  static DateTime lastInboxOpenTime = DateTime.now().subtract(const Duration(days: 30));
  
  final _client = Supabase.instance.client;

  /// Retorna o fluxo em tempo real de mensagens entre o usuário logado e outro usuário
  Stream<List<ChatMessageModel>> getMessagesStream(String currentUserId, String otherUserId) {
    return _client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: true)
        .map((maps) {
      // Filtra localmente porque o .stream() do Supabase com OR ainda pode ter limitações complexas
      // Mas as políticas de RLS garantem que só vem mensagens minhas (enviadas ou recebidas)
      return maps
          .where((row) =>
              (row['sender_id'] == currentUserId && row['receiver_id'] == otherUserId) ||
              (row['sender_id'] == otherUserId && row['receiver_id'] == currentUserId))
          .map((row) => ChatMessageModel.fromJson(row))
          .toList();
    });
  }

  /// Envia uma nova mensagem
  Future<void> sendMessage(String senderId, String receiverId, String content) async {
    if (content.trim().isEmpty) return;
    
    await _client.from('chat_messages').insert({
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content.trim(),
    });
  }
}
