import 'package:baroallgi/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:baroallgi/features/chat/data/repositories/chat_repository.dart';
import 'package:baroallgi/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:baroallgi/features/chat/models/chat_message_model.dart';
import 'package:baroallgi/features/chat/models/chat_room_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatDatasourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSource();
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(datasource: ref.watch(chatDatasourceProvider));
});

class ChatRoomsNotifier extends Notifier<List<ChatRoomModel>> {
  @override
  List<ChatRoomModel> build() {
    ref.watch(chatRepositoryProvider);
    return [];
  }

  String create() {
    final now = DateTime.now();
    final room = ChatRoomModel(
      id: now.microsecondsSinceEpoch.toString(),
      updatedAt: now,
    );
    state = [room, ...state];
    return room.id;
  }

  Future<void> send(String roomId, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final current = _find(roomId);
    if (current == null || current.isReplying) return;

    final asked = current.copyWith(
      updatedAt: DateTime.now(),
      isReplying: true,
      messages: [
        ...current.messages,
        ChatMessageModel(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          role: ChatRole.user,
          text: trimmed,
        ),
      ],
    );
    _replace(asked);

    try {
      final answer = await ref.read(chatRepositoryProvider).reply(asked.messages);
      final latest = _find(roomId);
      if (latest == null) return;
      _replace(
        latest.copyWith(
          updatedAt: DateTime.now(),
          isReplying: false,
          messages: [
            ...latest.messages,
            ChatMessageModel(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              role: ChatRole.assistant,
              text: answer,
            ),
          ],
        ),
      );
    } catch (error) {
      debugPrint('rlog :: chat reply error : $error');
      final latest = _find(roomId);
      if (latest == null) return;
      _replace(
        latest.copyWith(
          updatedAt: DateTime.now(),
          isReplying: false,
          messages: [
            ...latest.messages,
            ChatMessageModel(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              role: ChatRole.assistant,
              text: '답변을 가져오지 못했어요. 잠시 후 다시 보내 주세요.',
            ),
          ],
        ),
      );
    }
  }

  ChatRoomModel? _find(String roomId) {
    for (final room in state) {
      if (room.id == roomId) return room;
    }
    return null;
  }

  void _replace(ChatRoomModel room) {
    state = [room, ...state.where((item) => item.id != room.id)];
  }
}

final chatRoomsProvider = NotifierProvider<ChatRoomsNotifier, List<ChatRoomModel>>(
  ChatRoomsNotifier.new,
);
