/// 무료 회원 AI 챗 일일 사용량. Firestore `users/{uid}.aiChatDaily`.
class AiChatDailyUsage {
  /// Asia/Seoul 기준 `yyyy-MM-dd`.
  final String date;
  final int count;

  const AiChatDailyUsage({
    required this.date,
    required this.count,
  });

  static const freeDailyLimit = 5;

  factory AiChatDailyUsage.fromFirestore(Map<String, dynamic> data) {
    return AiChatDailyUsage(
      date: data['date'] as String? ?? '',
      count: data['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'date': date,
      'count': count,
    };
  }

  /// UTC+9 달력 날짜 문자열.
  static String seoulDateString([DateTime? now]) {
    final seoul = (now ?? DateTime.now()).toUtc().add(const Duration(hours: 9));
    final y = seoul.year.toString().padLeft(4, '0');
    final m = seoul.month.toString().padLeft(2, '0');
    final d = seoul.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

/// 무료 일일 한도 조회·소모 결과.
class AiChatDailyQuota {
  final bool isUnlimited;
  final int limit;
  final int used;
  final String date;

  const AiChatDailyQuota({
    required this.isUnlimited,
    required this.limit,
    required this.used,
    required this.date,
  });

  int get remaining {
    if (isUnlimited) return limit;
    final left = limit - used;
    return left < 0 ? 0 : left;
  }

  bool get isExhausted => !isUnlimited && remaining <= 0;

  factory AiChatDailyQuota.unlimited({required String date}) {
    return AiChatDailyQuota(
      isUnlimited: true,
      limit: AiChatDailyUsage.freeDailyLimit,
      used: 0,
      date: date,
    );
  }

  factory AiChatDailyQuota.free({
    required String date,
    required int used,
  }) {
    return AiChatDailyQuota(
      isUnlimited: false,
      limit: AiChatDailyUsage.freeDailyLimit,
      used: used,
      date: date,
    );
  }
}

class AiChatDailyLimitExceededException implements Exception {
  final int limit;
  final String date;

  const AiChatDailyLimitExceededException({
    required this.limit,
    required this.date,
  });

  @override
  String toString() =>
      'AiChatDailyLimitExceededException(limit: $limit, date: $date)';
}
