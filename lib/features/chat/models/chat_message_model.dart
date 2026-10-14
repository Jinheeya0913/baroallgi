enum ChatRole { user, assistant }

class ChatMessageModel {
  final String id;
  final ChatRole role;
  final String text;

  const ChatMessageModel({
    required this.id,
    required this.role,
    required this.text,
  });
}
