import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String uid;           // Firebase 고유 식별자
  final String email;         // 이메일
  final String displayName;   // 사용자 이름
  final String? photoUrl;     // 프로필 이미지 URL
  final bool emailVerified;   // 이메일 인증 여부
  final DateTime? createdAt;  // 계정 생성일
  final DateTime? lastLoginAt; // 마지막 로그인 시간

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.emailVerified,
    this.createdAt,
    this.lastLoginAt,
  });

  // 1. JSON으로부터 객체 생성 (API나 로컬 DB용)
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  // 2. 객체를 JSON으로 변환 (저장용)
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // 3. Firebase의 User 객체를 우리 앱의 모델로 변환 (가장 많이 쓰임)
  factory UserModel.fromFirebase(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime,
      lastLoginAt: user.metadata.lastSignInTime,
    );
  }

  // 4. 데이터 수정 시 필요한 copyWith
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}