import 'package:baroallgi/features/chat/models/chat_message_model.dart';
import 'package:firebase_ai/firebase_ai.dart';

class ChatRemoteDataSource {
  ChatRemoteDataSource()
    : _model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-3.8-flash',
        systemInstruction: Content.system(_instruction),
      );

  final GenerativeModel _model;

  static const _instruction = '''
당신은 바로알기 앱의 사실 확인 도우미다.
사용자가 보낸 소식, 광고, 문자, 건강 정보, 금융 안내가 사실인지 한국어로 살펴본다.
확실하지 않으면 그렇다고 말하고, 확인하는 방법을 짧게 안내한다.
의학 진단이나 법률 자문은 하지 않는다.
모든 답변은 간략하게 하며, 화살표 같은 이모지를 활용하여 시각적으로 분류하여 보여준다.
''';

  Future<String> reply(List<ChatMessageModel> messages) async {
    final response = await _model.generateContent([
      for (final message in messages)
        message.role == ChatRole.user
            ? Content.text(message.text)
            : Content.model([TextPart(message.text)]),
    ]);
    final text = response.text?.trim();
    if (text == null || text.isEmpty) {
      throw StateError('empty gemini response');
    }
    return text;
  }
}
