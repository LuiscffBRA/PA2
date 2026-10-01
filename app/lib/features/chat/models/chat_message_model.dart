import 'package:flutter/material.dart';

class ChatMessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime createdAt;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
    };
  }
}
