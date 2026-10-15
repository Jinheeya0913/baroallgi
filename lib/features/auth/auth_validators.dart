/// Firebase Auth 기본 비밀번호 정책(최소 6자)에 맞춘 검증.
/// 콘솔에서 Identity Platform 복잡도를 켜면 서버가 추가로 거부할 수 있다.
const firebaseAuthPasswordMinLength = 6;

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

String? validateNickname(String value) {
  final nickname = value.trim();
  if (nickname.isEmpty) {
    return '닉네임을 입력해주시길 바랍니다.';
  }
  if (nickname.length < 2) {
    return '닉네임은 2자 이상이어야 합니다.';
  }
  return null;
}

String? validateEmail(String value) {
  final email = value.trim();
  if (email.isEmpty) {
    return '이메일을 입력해주시길 바랍니다.';
  }
  if (!_emailPattern.hasMatch(email)) {
    return '올바른 이메일 형식이 아닙니다.';
  }
  return null;
}

String? validatePassword(String value) {
  if (value.isEmpty) {
    return '비밀번호를 입력해주시길 바랍니다.';
  }
  if (value.length < firebaseAuthPasswordMinLength) {
    return '비밀번호는 $firebaseAuthPasswordMinLength자 이상이어야 합니다.';
  }
  return null;
}
