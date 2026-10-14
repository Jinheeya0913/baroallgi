import 'package:baroallgi/features/chat/models/chat_message_model.dart';

abstract class ChatRepository {
  Future<String> reply(List<ChatMessageModel> messages);
}
