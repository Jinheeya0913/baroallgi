import 'package:flutter/material.dart';

class AppColors {
  // --- [신뢰/정보성 중심의 메인 컬러] ---
  /// Deep Navy: 앱의 메인 신뢰를 담당하는 딥 네이비
  static const Color primaryNavy = Color(0xFF1A3C6E);

  /// Trust Blue: 정보 강조 및 버튼에 사용하는 블루
  static const Color primaryBlue = Color(0xFF2A5BB1);

  static const Color subColorBlue = Color(0xFF64748B);

  static const Color subColorGhost = Color(0xFFF1F5F9);

  /// Sky Blue: 배경이나 강조 보조용 연한 블루
  static const Color accentBlue = Color(0xFFE0EAFC);

  // --- [상태 및 알림 컬러] ---
  /// Alert Red: 긴급 알림, 사기 주의 등 경고용 (차분한 레드)
  static const Color alertRed = Color(0xFFE53935);

  /// Soft Red: 긴급 알림 배경용
  static const Color softRed = Color(0xFFFFEBEE);

  // --- [무채색 및 배경] ---
  /// Background: 눈이 편안한 미색 배경
  static const Color background = Color(0xFFF8F9FB);

  /// Surface: 카드나 리스트 아이템의 배경 (순백색)
  static const Color surface = Colors.white;

  /// Text Primary: 기본 텍스트 (완전한 검정보다 눈이 편함)
  static const Color textPrimary = Color(0xFF222222);

  /// Text Secondary: 부제목, 보조 텍스트용
  static const Color textSecondary = Color(0xFF757575);

  /// Divider: 선이나 경계선용 (매우 연한 회색)
  static const Color divider = Color(0xFFEEEEEE);

  // --- [그라데이션 조합] ---
  static const List<Color> navyGradient = [primaryNavy, primaryBlue];

  // 구분별 색상

  static const Color fiance = Colors.blue;
  static const Color health = Colors.green;
  static const Color ad = Colors.orange;
  static const Color rumor = Colors.purple;
}