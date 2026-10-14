import 'package:baroallgi/features/chat/models/chat_message_model.dart';

class ChatRoomModel {
  final String id;
  final String? title;
  final DateTime updatedAt;
  final List<ChatMessageModel> messages;

  const ChatRoomModel({
    required this.id,
    required this.updatedAt,
    this.title,
    this.messages = const [],
  });

  ChatRoomModel copyWith({
    String? title,
    DateTime? updatedAt,
    List<ChatMessageModel>? messages,
  }) {
    return ChatRoomModel(
      id: id,
      title: title ?? this.title,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
    );
  }
}
