import 'package:baroallgi/features/chat/models/chat_message_model.dart';
import 'package:baroallgi/features/chat/models/chat_room_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomsNotifier extends Notifier<List<ChatRoomModel>> {
  @override
  List<ChatRoomModel> build() => [];

  String create() {
    final now = DateTime.now();
    final room = ChatRoomModel(
      id: now.microsecondsSinceEpoch.toString(),
      updatedAt: now,
    );
    state = [room, ...state];
    return room.id;
  }

  void send(String roomId, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final index = state.indexWhere((room) => room.id == roomId);
    if (index < 0) return;

    final updated = state[index].copyWith(
      updatedAt: DateTime.now(),
      messages: [
        ...state[index].messages,
        ChatMessageModel(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          role: ChatRole.user,
          text: trimmed,
        ),
      ],
    );
    state = [updated, ...state.where((room) => room.id != roomId)];
  }
}

final chatRoomsProvider = NotifierProvider<ChatRoomsNotifier, List<ChatRoomModel>>(
  ChatRoomsNotifier.new,
);
