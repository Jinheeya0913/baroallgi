// lib/core/const/app_metadata.dart 내부 추가 예시

class AppMetadata {
  // ... 기존 카테고리들 ...

  // 1. 팩트체크 판정 기준
  static const List<Map<String, dynamic>> factStatuses = [
    {'id': 'FAKE', 'label': '허위/가짜', 'color': 'red', 'icon': 'cancel'},
    {'id': 'CAUTION', 'label': '주의/왜곡', 'color': 'orange', 'icon': 'warning'},
    {'id': 'TRUE', 'label': '사실', 'color': 'green', 'icon': 'check_circle'},
    {'id': 'UNKNOWN', 'label': '판단유보', 'color': 'grey', 'icon': 'help'},
  ];

  // 2. 검증 기관/분야 (전문가 프로필용)
  static const List<String> expertFields = [
    '의료/보건',
    '금융/법률',
    'IT/보안',
    '소비자 보호',
    '언론/팩트체크',
  ];

  static const List<Map<String, dynamic>> reportCategories = [
    {'id': 'finance', 'name': '금융사기', 'icon': 'account_balance'},
    {'id': 'health', 'name': '의학/건강', 'icon': 'medical_services'},
    {'id': 'ad', 'name': '허위광고', 'icon': 'ad_units'},
    {'id': 'rumor', 'name': 'SNS찌라시', 'icon': 'forum'},
  ];

}