import 'package:cloud_firestore/cloud_firestore.dart';

enum ChatRole { user, assistant }

class ChatMessageModel {
  final String id;
  final ChatRole role;
  final String text;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.id,
    required this.role,
    required this.text,
    required this.createdAt,
  });

  factory ChatMessageModel.fromFirestore(String id, Map<String, dynamic> data) {
    final createdAt = data['createdAt'];
    return ChatMessageModel(
      id: id,
      role: data['role'] == ChatRole.assistant.name
          ? ChatRole.assistant
          : ChatRole.user,
      text: data['text'] as String? ?? '',
      createdAt: createdAt is Timestamp
          ? createdAt.toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'role': role.name,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
