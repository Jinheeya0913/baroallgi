

import 'package:baroallgi/features/auth/models/auth_model.dart';

abstract class AuthRepository {
  Future <AuthModel> signIn(String email, String password);
  Future <AuthModel> signUp(String email, String password);
  AuthModel? currentUser();
}