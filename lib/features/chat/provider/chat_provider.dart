import 'package:baroallgi/features/chat/models/chat_message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatNotifier extends AutoDisposeNotifier<List<ChatMessageModel>> {
  @override
  List<ChatMessageModel> build() {
    return const [
      ChatMessageModel(
        id: 'intro',
        role: ChatRole.assistant,
        text: '어떤 내용이 궁금한가요? 소식, 광고, 문자 내용을 적어 주시면 함께 살펴볼게요.',
      ),
    ];
  }

  void send(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    state = [
      ...state,
      ChatMessageModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        role: ChatRole.user,
        text: trimmed,
      ),
    ];
  }
}

final chatProvider =
    NotifierProvider.autoDispose<ChatNotifier, List<ChatMessageModel>>(
      ChatNotifier.new,
    );
