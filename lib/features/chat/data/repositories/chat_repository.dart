import 'package:baroallgi/features/chat/models/chat_message_model.dart';
import 'package:baroallgi/features/chat/models/chat_room_model.dart';

abstract class ChatRepository {
  Future<String> reply(List<ChatMessageModel> messages);

  Future<String> generateTitle(String firstQuestion);

  Future<List<ChatRoomModel>> fetchRooms(String uid);

  Future<List<ChatMessageModel>> fetchMessages(String uid, String roomId);

  Future<void> createRoom(String uid, ChatRoomModel room);

  Future<void> saveMessage(
    String uid,
    String roomId,
    ChatMessageModel message,
  );

  Future<void> updateRoom(String uid, ChatRoomModel room);

  Future<void> deleteRoom(String uid, String roomId);
}
