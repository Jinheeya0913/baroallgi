import 'package:baroallgi/core/const/const_code.dart';
import 'package:baroallgi/core/provider/storage_provider.dart';
import 'package:baroallgi/features/auth/data/repositories/auth_repository.dart';
import 'package:baroallgi/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:baroallgi/features/auth/models/auth_model.dart';
import 'package:baroallgi/features/auth/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthModel?>((
  ref,
) {
  return AuthNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(storageProvider),
  );
});

class AuthNotifier extends StateNotifier<AuthModel?> {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _storage;

  AuthNotifier(this._authRepository, this._storage)
    : super(null) {
    _checkAutoLogin();
  } // 초기값 : 로그아웃 상태

  ///  자동 로그인 체크
  Future<void> _checkAutoLogin() async {
    final autoLogin = await _storage.read(key: 'useAutoLogin');

    if (autoLogin == 'true') {
      final user = FirebaseAuth.instance.currentUser;
      // firebase SDK에서 최근 접속한 유저 정보에 대해 알아서 토근까지 검증해줌.
      if (user != null) {
        state = AuthModel(
          authResultCode: '00',
          authStatusCode: AUTH_STATUS_LOGIN,
          userModel: UserModel.fromFirebase(user),
        );
      }
    }
  }

  /// 로그인
  Future<void> signIn({required String email, required String password}) async {
    final result = await _authRepository.signIn(email, password);
    state = result;
  }


  /// 회원가입
  Future<void> signUp({required String email, required String password}) async {
    try {
      // 1. Repository의 signUp 호출
      final result = await _authRepository.signUp(email, password);

      // 2. 결과 상태 반영 (성공 시 유저 정보가 state에 담김)
      state = result;
    } catch (e) {
      state = AuthModel(
        authResultCode: '99',
        authResultMsg: '회원가입 중 오류가 발생했습니다: $e',
      );
    }
  }

  AuthModel? logout(AuthModel auth) {
    state = null;
    _storage.delete(key: 'useAutoLogin');
    
    print('rlog :: 로그아웃 성공');
    return state;
  }
}
