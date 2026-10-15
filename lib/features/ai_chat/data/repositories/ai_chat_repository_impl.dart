import 'package:baroallgi/features/ai_chat/data/datasources/ai_chat_remote_datasource.dart';
import 'package:baroallgi/features/ai_chat/data/repositories/ai_chat_repository.dart';
import 'package:baroallgi/features/ai_chat/models/ai_chat_keyword.dart';
import 'package:baroallgi/features/ai_chat/models/ai_chat_message_model.dart';
import 'package:baroallgi/features/ai_chat/models/ai_chat_room_model.dart';

class AiChatRepositoryImpl implements AiChatRepository {
  AiChatRepositoryImpl({required AiChatRemoteDataSource datasource})
    : _datasource = datasource;

  final AiChatRemoteDataSource _datasource;

  @override
  Future<String> reply(List<AiChatMessageModel> messages) {
    return _datasource.reply(messages);
  }

  @override
  Future<AiChatRoomMeta> generateRoomMeta(String firstQuestion) {
    return _datasource.generateRoomMeta(firstQuestion);
  }

  @override
  Future<List<AiChatRoomModel>> fetchRooms(String uid) {
    return _datasource.fetchRooms(uid);
  }

  @override
  Future<List<AiChatMessageModel>> fetchMessages(String uid, String roomId) {
    return _datasource.fetchMessages(uid, roomId);
  }

  @override
  Future<void> createRoom(String uid, AiChatRoomModel room) {
    return _datasource.createRoom(uid, room);
  }

  @override
  Future<void> saveMessage(
    String uid,
    String roomId,
    AiChatMessageModel message,
  ) {
    return _datasource.saveMessage(uid, roomId, message);
  }

  @override
  Future<void> updateRoom(String uid, AiChatRoomModel room) {
    return _datasource.updateRoom(uid, room);
  }

  @override
  Future<void> deleteRoom(String uid, String roomId) {
    return _datasource.deleteRoom(uid, roomId);
  }
}
