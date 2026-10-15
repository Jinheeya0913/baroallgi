import 'package:baroallgi/core/provider/firebase_provider.dart';
import 'package:baroallgi/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:baroallgi/features/chat/data/repositories/chat_repository.dart';
import 'package:baroallgi/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:baroallgi/features/chat/models/chat_message_model.dart';
import 'package:baroallgi/features/chat/models/chat_room_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatDatasourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSource(firestore: ref.watch(firestoreProvider));
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(datasource: ref.watch(chatDatasourceProvider));
});

class ChatRoomsNotifier extends Notifier<List<ChatRoomModel>> {
  @override
  List<ChatRoomModel> build() {
    ref.watch(chatRepositoryProvider);
    Future.microtask(loadRooms);
    return [];
  }

  String? get _uid => ref.read(firebaseAuthProvider).currentUser?.uid;

  Future<void> loadRooms() async {
    final uid = _uid;
    if (uid == null) {
      state = state.where((room) => !room.isPersisted).toList();
      return;
    }

    try {
      final rooms = await ref.read(chatRepositoryProvider).fetchRooms(uid);
      final drafts = state.where((room) => !room.isPersisted).toList();
      state = [...drafts, ...rooms];
    } catch (error) {
      debugPrint('rlog :: chat loadRooms error : $error');
    }
  }

  String create() {
    final now = DateTime.now();
    final room = ChatRoomModel(
      id: now.microsecondsSinceEpoch.toString(),
      createdAt: now,
      updatedAt: now,
      messagesLoaded: true,
      isPersisted: false,
    );
    state = [room, ...state];
    return room.id;
  }

  Future<void> openRoom(String roomId) async {
    final current = _find(roomId);
    if (current == null) return;
    if (current.messagesLoaded || !current.isPersisted) return;

    final uid = _uid;
    if (uid == null) return;

    try {
      final messages = await ref
          .read(chatRepositoryProvider)
          .fetchMessages(uid, roomId);
      final latest = _find(roomId);
      if (latest == null) return;
      _replace(
        latest.copyWith(
          messages: messages,
          messagesLoaded: true,
        ),
      );
    } catch (error) {
      debugPrint('rlog :: chat openRoom error : $error');
    }
  }

  Future<void> sendTest(String roomId) async {
    const testQuestion = '테스트';
    const testAnswer =
        '이건 테스트 응답이에요.\n→ AI를 호출하지 않았고\n→ 화면·저장 흐름만 확인하는 고정 메시지입니다.';

    final current = _find(roomId);
    if (current == null || current.isReplying) return;

    final now = DateTime.now();
    final userMessage = ChatMessageModel(
      id: now.microsecondsSinceEpoch.toString(),
      role: ChatRole.user,
      text: testQuestion,
      createdAt: now,
    );
    final asked = current.copyWith(
      updatedAt: now,
      lastMessageText: testQuestion,
      isReplying: true,
      messagesLoaded: true,
      messages: [...current.messages, userMessage],
    );
    _replace(asked);

    final uid = _uid;
    if (uid != null) {
      try {
        await _persistUserTurn(uid, asked, userMessage);
      } catch (error) {
        debugPrint('rlog :: chat save test user turn error : $error');
      }
    }

    await Future<void>.delayed(const Duration(milliseconds: 400));

    final answeredAt = DateTime.now();
    final assistantMessage = ChatMessageModel(
      id: answeredAt.microsecondsSinceEpoch.toString(),
      role: ChatRole.assistant,
      text: testAnswer,
      createdAt: answeredAt,
    );
    final latest = _find(roomId);
    if (latest == null) return;
    final answered = latest.copyWith(
      title: latest.title ?? '테스트',
      updatedAt: answeredAt,
      lastMessageText: testAnswer,
      isReplying: false,
      isPersisted: uid != null,
      messages: [...latest.messages, assistantMessage],
    );
    _replace(answered);

    if (uid == null) return;
    try {
      await _persistAssistantTurn(uid, answered, assistantMessage);
    } catch (error) {
      debugPrint('rlog :: chat save test assistant turn error : $error');
    }
  }

  Future<void> send(String roomId, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final current = _find(roomId);
    if (current == null || current.isReplying) return;

    final now = DateTime.now();
    final userMessage = ChatMessageModel(
      id: now.microsecondsSinceEpoch.toString(),
      role: ChatRole.user,
      text: trimmed,
      createdAt: now,
    );
    final asked = current.copyWith(
      updatedAt: now,
      lastMessageText: trimmed,
      isReplying: true,
      messagesLoaded: true,
      messages: [...current.messages, userMessage],
    );
    _replace(asked);

    final uid = _uid;
    if (uid == null) {
      _replace(
        asked.copyWith(
          isReplying: false,
          messages: [
            ...asked.messages,
            ChatMessageModel(
              id: '${now.microsecondsSinceEpoch}_err',
              role: ChatRole.assistant,
              text: '대화를 저장하려면 로그인해 주세요.',
              createdAt: DateTime.now(),
            ),
          ],
        ),
      );
      return;
    }

    try {
      await _persistUserTurn(uid, asked, userMessage);
    } catch (error) {
      debugPrint('rlog :: chat save user turn error : $error');
    }

    try {
      final repository = ref.read(chatRepositoryProvider);
      final answer = await repository.reply(asked.messages);
      final answeredAt = DateTime.now();
      final assistantMessage = ChatMessageModel(
        id: answeredAt.microsecondsSinceEpoch.toString(),
        role: ChatRole.assistant,
        text: answer,
        createdAt: answeredAt,
      );

      var title = asked.title;
      final needsTitle = title == null || title.trim().isEmpty;
      if (needsTitle) {
        try {
          title = await repository.generateTitle(trimmed);
        } catch (error) {
          debugPrint('rlog :: chat title error : $error');
          title = _fallbackTitle(trimmed);
        }
      }

      final latest = _find(roomId);
      if (latest == null) return;
      final answered = latest.copyWith(
        title: title,
        updatedAt: answeredAt,
        lastMessageText: answer,
        isReplying: false,
        isPersisted: true,
        messages: [...latest.messages, assistantMessage],
      );
      _replace(answered);
      await _persistAssistantTurn(uid, answered, assistantMessage);
    } catch (error) {
      debugPrint('rlog :: chat reply error : $error');
      final latest = _find(roomId);
      if (latest == null) return;
      final failed = latest.copyWith(
        updatedAt: DateTime.now(),
        isReplying: false,
        messages: [
          ...latest.messages,
          ChatMessageModel(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            role: ChatRole.assistant,
            text: '답변을 가져오지 못했어요. 잠시 후 다시 보내 주세요.',
            createdAt: DateTime.now(),
          ),
        ],
      );
      _replace(failed);
    }
  }

  String _fallbackTitle(String question) {
    final compact = question.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (compact.length <= 20) return compact;
    return '${compact.substring(0, 20)}…';
  }

  Future<void> _persistUserTurn(
    String uid,
    ChatRoomModel room,
    ChatMessageModel userMessage,
  ) async {
    final repository = ref.read(chatRepositoryProvider);
    if (!room.isPersisted) {
      await repository.createRoom(uid, room.copyWith(isPersisted: true));
    } else {
      await repository.updateRoom(uid, room);
    }
    await repository.saveMessage(uid, room.id, userMessage);
    final latest = _find(room.id);
    if (latest == null) return;
    _replace(latest.copyWith(isPersisted: true));
  }

  Future<void> _persistAssistantTurn(
    String uid,
    ChatRoomModel room,
    ChatMessageModel assistantMessage,
  ) async {
    final repository = ref.read(chatRepositoryProvider);
    await repository.saveMessage(uid, room.id, assistantMessage);
    await repository.updateRoom(uid, room);
  }

  Future<void> delete(String roomId) async {
    final current = _find(roomId);
    if (current == null) return;

    if (current.isPersisted) {
      final uid = _uid;
      if (uid == null) {
        throw StateError('chat delete requires a signed-in user');
      }
      try {
        await ref.read(chatRepositoryProvider).deleteRoom(uid, roomId);
      } catch (error) {
        debugPrint('rlog :: chat delete error : $error');
        rethrow;
      }
    }

    state = state.where((room) => room.id != roomId).toList();
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
