import 'package:baroallgi/features/ai_chat/models/ai_chat_message_model.dart';
import 'package:baroallgi/features/ai_chat/models/ai_chat_room_model.dart';

abstract class AiChatRepository {
  Future<String> reply(List<AiChatMessageModel> messages);

  Future<String> generateTitle(String firstQuestion);

  Future<List<AiChatRoomModel>> fetchRooms(String uid);

  Future<List<AiChatMessageModel>> fetchMessages(String uid, String roomId);

  Future<void> createRoom(String uid, AiChatRoomModel room);

  Future<void> saveMessage(
    String uid,
    String roomId,
    AiChatMessageModel message,
  );

  Future<void> updateRoom(String uid, AiChatRoomModel room);

  Future<void> deleteRoom(String uid, String roomId);
}
