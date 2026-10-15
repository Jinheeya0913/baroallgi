import 'package:baroallgi/features/auth/models/user_plan.dart';
import 'package:baroallgi/features/auth/models/user_subscription.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAddInfoModel {
  final String uid;
  final String nickname;
  final String eggHashcode;
  final UserPlan plan;
  final DateTime createdAt;
  final UserSubscription? subscription;

  const UserAddInfoModel({
    required this.uid,
    required this.nickname,
    required this.eggHashcode,
    required this.plan,
    required this.createdAt,
    this.subscription,
  });

  factory UserAddInfoModel.free({
    required String uid,
    required String nickname,
    required String eggHashcode,
    DateTime? createdAt,
  }) {
    return UserAddInfoModel(
      uid: uid,
      nickname: nickname,
      eggHashcode: eggHashcode,
      plan: UserPlan.free,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  factory UserAddInfoModel.fromFirestore(String uid, Map<String, dynamic> data) {
    final createdAt = data['createdAt'];
    final planName = data['plan'] as String? ?? UserPlan.free.name;
    final subscriptionData = data['subscription'];
    return UserAddInfoModel(
      uid: uid,
      nickname: data['nickname'] as String? ?? '',
      eggHashcode: data['egg_hashcode'] as String? ?? '',
      plan: UserPlan.values.firstWhere(
        (value) => value.name == planName,
        orElse: () => UserPlan.free,
      ),
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
      subscription: subscriptionData is Map<String, dynamic>
          ? UserSubscription.fromFirestore(subscriptionData)
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nickname': nickname,
      'egg_hashcode': eggHashcode,
      'plan': plan.name,
      'createdAt': Timestamp.fromDate(createdAt),
      if (subscription != null) 'subscription': subscription!.toFirestore(),
    };
  }

  bool get isPaidActive {
    if (plan != UserPlan.paid) return false;
    final expiresAt = subscription?.expiresAt;
    if (expiresAt == null) return false;
    return expiresAt.isAfter(DateTime.now());
  }

  UserAddInfoModel copyWith({
    String? nickname,
    String? eggHashcode,
    UserPlan? plan,
    DateTime? createdAt,
    UserSubscription? subscription,
  }) {
    return UserAddInfoModel(
      uid: uid,
      nickname: nickname ?? this.nickname,
      eggHashcode: eggHashcode ?? this.eggHashcode,
      plan: plan ?? this.plan,
      createdAt: createdAt ?? this.createdAt,
      subscription: subscription ?? this.subscription,
    );
  }
}
