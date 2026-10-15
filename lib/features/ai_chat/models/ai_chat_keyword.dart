/// 홈 메뉴 네 분류 + 애매/그외용 `기타`.
/// Firestore `users/{uid}/chats/{id}.keyword`에 저장.
enum AiChatKeyword {
  finance('금융'),
  medical('의학'),
  ad('광고'),
  snsRumor('sns 루머'),
  other('기타');

  const AiChatKeyword(this.firestoreValue);

  /// Firestore·관리자 통계용 고정 문자열.
  final String firestoreValue;

  static AiChatKeyword? tryParse(String? raw) {
    if (raw == null) return null;
    final normalized = raw.trim().toLowerCase();
    if (normalized.isEmpty) return AiChatKeyword.other;

    for (final value in AiChatKeyword.values) {
      if (value.firestoreValue.toLowerCase() == normalized) return value;
      if (value.name.toLowerCase() == normalized) return value;
    }

    if (normalized.contains('기타') ||
        normalized.contains('other') ||
        normalized.contains('etc') ||
        normalized.contains('그외') ||
        normalized.contains('그 외')) {
      return AiChatKeyword.other;
    }
    if (normalized.contains('금융') ||
        normalized.contains('finance') ||
        normalized.contains('대출') ||
        normalized.contains('피싱')) {
      return AiChatKeyword.finance;
    }
    if (normalized.contains('의학') ||
        normalized.contains('medical') ||
        normalized.contains('건강') ||
        normalized.contains('의료')) {
      return AiChatKeyword.medical;
    }
    if (normalized.contains('광고') ||
        normalized.contains('ad') ||
        normalized.contains('쇼핑') ||
        normalized.contains('세일')) {
      return AiChatKeyword.ad;
    }
    if (normalized.contains('루머') ||
        normalized.contains('rumor') ||
        normalized.contains('sns') ||
        normalized.contains('찌라시') ||
        normalized.contains('유언비어')) {
      return AiChatKeyword.snsRumor;
    }
    return AiChatKeyword.other;
  }
}

/// 첫 질문으로 만든 방 제목 + keyword.
class AiChatRoomMeta {
  final String title;
  final AiChatKeyword keyword;

  const AiChatRoomMeta({
    required this.title,
    this.keyword = AiChatKeyword.other,
  });
}
