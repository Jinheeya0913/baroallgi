import 'package:baroallgi/features/ai_chat/models/ai_chat_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AiChatRoomModel {
  final String id;
  final String? title;
  final String? lastMessageText;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<AiChatMessageModel> messages;
  final bool isReplying;
  final bool messagesLoaded;
  final bool isPersisted;

  const AiChatRoomModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.title,
    this.lastMessageText,
    this.messages = const [],
    this.isReplying = false,
    this.messagesLoaded = false,
    this.isPersisted = false,
  });

  factory AiChatRoomModel.fromFirestore(String id, Map<String, dynamic> data) {
    final createdAt = data['createdAt'];
    final updatedAt = data['updatedAt'];
    return AiChatRoomModel(
      id: id,
      title: data['title'] as String?,
      lastMessageText: data['lastMessageText'] as String?,
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
      updatedAt: updatedAt is Timestamp ? updatedAt.toDate() : DateTime.now(),
      messagesLoaded: false,
      isPersisted: true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'lastMessageText': lastMessageText,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  AiChatRoomModel copyWith({
    String? title,
    String? lastMessageText,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<AiChatMessageModel>? messages,
    bool? isReplying,
    bool? messagesLoaded,
    bool? isPersisted,
  }) {
    return AiChatRoomModel(
      id: id,
      title: title ?? this.title,
      lastMessageText: lastMessageText ?? this.lastMessageText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
      isReplying: isReplying ?? this.isReplying,
      messagesLoaded: messagesLoaded ?? this.messagesLoaded,
      isPersisted: isPersisted ?? this.isPersisted,
    );
  }
}
