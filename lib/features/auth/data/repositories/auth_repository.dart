import 'package:baroallgi/features/auth/models/auth_model.dart';

abstract class AuthRepository {
  Future<AuthModel> signIn(String email, String password);

  Future<AuthModel> signUp({
    required String email,
    required String password,
    required String nickname,
  });

  AuthModel? currentUser();
}
