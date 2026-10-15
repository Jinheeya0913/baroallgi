import 'package:baroallgi/features/ai_chat/models/ai_chat_message_model.dart';
import 'package:baroallgi/features/ai_chat/models/ai_chat_room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';

class AiChatRemoteDataSource {
  AiChatRemoteDataSource({required FirebaseFirestore firestore})
    : _firestore = firestore,
      _model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-3.8-flash',
        systemInstruction: Content.system(_instruction),
      ),
      _titleModel = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-3.8-flash',
        systemInstruction: Content.system(_titleInstruction),
      );

  final FirebaseFirestore _firestore;
  final GenerativeModel _model;
  final GenerativeModel _titleModel;

  static const _instruction = '''
당신은 바로알기 앱의 사실 확인 도우미다.
사용자가 보낸 소식, 광고, 문자, 건강 정보, 금융 안내가 사실인지 한국어로 살펴본다.
확실하지 않으면 그렇다고 말하고, 확인하는 방법을 짧게 안내한다.
의학 진단이나 법률 자문은 하지 않는다.
모든 답변은 간략하게 하며, 화살표 같은 이모지를 활용하여 시각적으로 분류하여 보여준다
상세설명은 '~함, ~임' 정도의 간단한 종결어미를 사용한다
답변은 1000자를 넘지 않도록 한다
''';

  static const _titleInstruction = '''
대화방 제목만 만든다.
한국어로 짧게, 최대 20자로 쓴다.
따옴표, 설명, 문장 부호 꾸밈 없이 제목 텍스트만 출력한다.
''';

  CollectionReference<Map<String, dynamic>> _chats(String uid) {
    return _firestore.collection('users').doc(uid).collection('chats');
  }

  CollectionReference<Map<String, dynamic>> _messages(String uid, String roomId) {
    return _chats(uid).doc(roomId).collection('messages');
  }

  Future<String> reply(List<AiChatMessageModel> messages) async {
    final response = await _model.generateContent([
      for (final message in messages)
        message.role == AiChatRole.user
            ? Content.text(message.text)
            : Content.model([TextPart(message.text)]),
    ]);
    final text = response.text?.trim();
    if (text == null || text.isEmpty) {
      throw StateError('empty gemini response');
    }
    return text;
  }

  Future<String> generateTitle(String firstQuestion) async {
    final response = await _titleModel.generateContent([
      Content.text('사용자 첫 질문: $firstQuestion'),
    ]);
    final text = response.text
        ?.trim()
        .replaceAll(RegExp(r'''^["“”']+|["“”']+$'''), '');
    if (text == null || text.isEmpty) {
      throw StateError('empty title response');
    }
    if (text.length <= 20) return text;
    return text.substring(0, 20);
  }

  Future<List<AiChatRoomModel>> fetchRooms(String uid) async {
    final snapshot = await _chats(uid)
        .orderBy('updatedAt', descending: true)
        .get();
    return [
      for (final doc in snapshot.docs)
        AiChatRoomModel.fromFirestore(doc.id, doc.data()),
    ];
  }

  Future<List<AiChatMessageModel>> fetchMessages(String uid, String roomId) async {
    final snapshot = await _messages(uid, roomId)
        .orderBy('createdAt')
        .get();
    return [
      for (final doc in snapshot.docs)
        AiChatMessageModel.fromFirestore(doc.id, doc.data()),
    ];
  }

  Future<void> createRoom(String uid, AiChatRoomModel room) async {
    await _chats(uid).doc(room.id).set(room.toFirestore());
  }

  Future<void> saveMessage(
    String uid,
    String roomId,
    AiChatMessageModel message,
  ) async {
    await _messages(uid, roomId).doc(message.id).set(message.toFirestore());
  }

  Future<void> updateRoom(String uid, AiChatRoomModel room) async {
    await _chats(uid).doc(room.id).set(room.toFirestore(), SetOptions(merge: true));
  }

  Future<void> deleteRoom(String uid, String roomId) async {
    final messages = _messages(uid, roomId);
    while (true) {
      final snapshot = await messages.limit(400).get();
      if (snapshot.docs.isEmpty) break;
      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      if (snapshot.docs.length < 400) break;
    }
    await _chats(uid).doc(roomId).delete();
  } 
}
