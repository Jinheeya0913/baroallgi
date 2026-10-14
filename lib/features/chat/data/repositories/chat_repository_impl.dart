import 'package:baroallgi/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:baroallgi/features/chat/data/repositories/chat_repository.dart';
import 'package:baroallgi/features/chat/models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({required ChatRemoteDataSource datasource})
    : _datasource = datasource;

  final ChatRemoteDataSource _datasource;

  @override
  Future<String> reply(List<ChatMessageModel> messages) {
    return _datasource.reply(messages);
  }
}
