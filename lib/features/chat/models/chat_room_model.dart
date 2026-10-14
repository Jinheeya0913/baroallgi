import 'package:baroallgi/features/chat/models/chat_message_model.dart';

class ChatRoomModel {
  final String id;
  final String? title;
  final DateTime updatedAt;
  final List<ChatMessageModel> messages;
  final bool isReplying;

  const ChatRoomModel({
    required this.id,
    required this.updatedAt,
    this.title,
    this.messages = const [],
    this.isReplying = false,
  });

  ChatRoomModel copyWith({
    String? title,
    DateTime? updatedAt,
    List<ChatMessageModel>? messages,
    bool? isReplying,
  }) {
    return ChatRoomModel(
      id: id,
      title: title ?? this.title,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
      isReplying: isReplying ?? this.isReplying,
    );
  }
}
