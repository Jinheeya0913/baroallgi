import 'package:cloud_firestore/cloud_firestore.dart';

class UserSubscription {
  final DateTime startedAt;
  final int periodDays;
  final DateTime expiresAt;
  final String? productId;

  const UserSubscription({
    required this.startedAt,
    required this.periodDays,
    required this.expiresAt,
    this.productId,
  });

  factory UserSubscription.fromFirestore(Map<String, dynamic> data) {
    final startedAt = data['startedAt'];
    final expiresAt = data['expiresAt'];
    return UserSubscription(
      startedAt: startedAt is Timestamp ? startedAt.toDate() : DateTime.now(),
      periodDays: data['periodDays'] as int? ?? 0,
      expiresAt: expiresAt is Timestamp ? expiresAt.toDate() : DateTime.now(),
      productId: data['productId'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'startedAt': Timestamp.fromDate(startedAt),
      'periodDays': periodDays,
      'expiresAt': Timestamp.fromDate(expiresAt),
      if (productId != null) 'productId': productId,
    };
  }
}
