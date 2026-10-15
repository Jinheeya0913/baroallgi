import 'package:baroallgi/features/auth/models/auth_model.dart';

abstract class AuthRepository {
  Future<AuthModel> signIn(String email, String password);

  Future<AuthModel> signUp({
    required String email,
    required String password,
    required String nickname,
  });

  AuthModel? currentUser();

  /// Auth 세션 + Firestore addInfo를 함께 읽는다. 자동 로그인용.
  Future<AuthModel?> loadCurrentUser();
}
