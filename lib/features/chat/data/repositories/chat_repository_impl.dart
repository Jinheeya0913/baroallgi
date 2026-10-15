import 'package:baroallgi/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:baroallgi/features/chat/data/repositories/chat_repository.dart';
import 'package:baroallgi/features/chat/models/chat_message_model.dart';
import 'package:baroallgi/features/chat/models/chat_room_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({required ChatRemoteDataSource datasource})
    : _datasource = datasource;

  final ChatRemoteDataSource _datasource;

  @override
  Future<String> reply(List<ChatMessageModel> messages) {
    return _datasource.reply(messages);
  }

  @override
  Future<String> generateTitle(String firstQuestion) {
    return _datasource.generateTitle(firstQuestion);
  }

  @override
  Future<List<ChatRoomModel>> fetchRooms(String uid) {
    return _datasource.fetchRooms(uid);
  }

  @override
  Future<List<ChatMessageModel>> fetchMessages(String uid, String roomId) {
    return _datasource.fetchMessages(uid, roomId);
  }

  @override
  Future<void> createRoom(String uid, ChatRoomModel room) {
    return _datasource.createRoom(uid, room);
  }

  @override
  Future<void> saveMessage(
    String uid,
    String roomId,
    ChatMessageModel message,
  ) {
    return _datasource.saveMessage(uid, roomId, message);
  }

  @override
  Future<void> updateRoom(String uid, ChatRoomModel room) {
    return _datasource.updateRoom(uid, room);
  }

  @override
  Future<void> deleteRoom(String uid, String roomId) {
    return _datasource.deleteRoom(uid, roomId);
  }
}
