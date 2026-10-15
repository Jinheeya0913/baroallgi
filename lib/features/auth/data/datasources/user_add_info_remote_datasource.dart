import 'package:baroallgi/features/auth/egg_hashcode.dart';
import 'package:baroallgi/features/auth/models/ai_chat_daily_usage.dart';
import 'package:baroallgi/features/auth/models/user_add_info_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAddInfoRemoteDataSource {
  UserAddInfoRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  static const _maxHashcodeAttempts = 8;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  CollectionReference<Map<String, dynamic>> get _hashcodes {
    return _firestore.collection('egg_hashcodes');
  }

  Future<UserAddInfoModel?> fetch(String uid) async {
    final snapshot = await _userDoc(uid).get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) return null;
    return UserAddInfoModel.fromFirestore(uid, data);
  }

  Future<AiChatDailyQuota> fetchAiChatDailyQuota(String uid) async {
    final addInfo = await fetch(uid);
    final today = AiChatDailyUsage.seoulDateString();
    if (addInfo == null) {
      return AiChatDailyQuota.free(date: today, used: 0);
    }
    if (addInfo.isPaidActive) {
      return AiChatDailyQuota.unlimited(date: today);
    }
    final daily = addInfo.aiChatDaily;
    final used = (daily != null && daily.date == today) ? daily.count : 0;
    return AiChatDailyQuota.free(date: today, used: used);
  }

  /// 무료면 오늘 카운트를 1 올리고, 한도면 [AiChatDailyLimitExceededException].
  /// 유료(유효 구독)면 카운트 없이 unlimited 쿼타를 반환한다.
  Future<AiChatDailyQuota> consumeAiChatDailyTurn(String uid) async {
    final userRef = _userDoc(uid);
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      final today = AiChatDailyUsage.seoulDateString();
      final data = snapshot.data();
      if (!snapshot.exists || data == null) {
        throw StateError('user addInfo missing');
      }

      final addInfo = UserAddInfoModel.fromFirestore(uid, data);
      if (addInfo.isPaidActive) {
        return AiChatDailyQuota.unlimited(date: today);
      }

      final daily = addInfo.aiChatDaily;
      final used = (daily != null && daily.date == today) ? daily.count : 0;
      if (used >= AiChatDailyUsage.freeDailyLimit) {
        throw AiChatDailyLimitExceededException(
          limit: AiChatDailyUsage.freeDailyLimit,
          date: today,
        );
      }

      final next = AiChatDailyUsage(date: today, count: used + 1);
      transaction.set(
        userRef,
        {'aiChatDaily': next.toFirestore()},
        SetOptions(merge: true),
      );
      return AiChatDailyQuota.free(date: today, used: next.count);
    });
  }

  /// 무료 가입 addInfo를 쓰고, egg_hashcode 유니크 인덱스를 함께 만든다.
  Future<UserAddInfoModel> createFreeAddInfo({
    required String uid,
    required String nickname,
  }) async {
    for (var attempt = 0; attempt < _maxHashcodeAttempts; attempt++) {
      final code = generateEggHashcode();
      final hashRef = _hashcodes.doc(code);
      final userRef = _userDoc(uid);

      try {
        return await _firestore.runTransaction((transaction) async {
          final existing = await transaction.get(hashRef);
          if (existing.exists) {
            throw StateError('egg_hashcode_collision');
          }

          final addInfo = UserAddInfoModel.free(
            uid: uid,
            nickname: nickname.trim(),
            eggHashcode: code,
          );

          transaction.set(hashRef, {
            'uid': uid,
            'createdAt': Timestamp.fromDate(addInfo.createdAt),
          });
          transaction.set(userRef, addInfo.toFirestore());
          return addInfo;
        });
      } on StateError catch (error) {
        if (error.message == 'egg_hashcode_collision') {
          continue;
        }
        rethrow;
      }
    }

    throw StateError('egg_hashcode를 발급하지 못했습니다. 다시 시도해주세요.');
  }
}
