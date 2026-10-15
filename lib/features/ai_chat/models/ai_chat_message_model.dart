import 'package:cloud_firestore/cloud_firestore.dart';

enum AiChatRole { user, assistant }

class AiChatMessageModel {
  final String id;
  final AiChatRole role;
  final String text;
  final DateTime createdAt;

  const AiChatMessageModel({
    required this.id,
    required this.role,
    required this.text,
    required this.createdAt,
  });

  factory AiChatMessageModel.fromFirestore(String id, Map<String, dynamic> data) {
    final createdAt = data['createdAt'];
    return AiChatMessageModel(
      id: id,
      role: data['role'] == AiChatRole.assistant.name
          ? AiChatRole.assistant
          : AiChatRole.user,
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
