import 'package:baroallgi/core/provider/firebase_provider.dart';
import 'package:baroallgi/core/provider/storage_provider.dart';
import 'package:baroallgi/features/auth/data/datasources/user_add_info_remote_datasource.dart';
import 'package:baroallgi/features/auth/data/repositories/auth_repository.dart';
import 'package:baroallgi/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:baroallgi/features/auth/models/auth_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthModel?>((
  ref,
) {
  return AuthNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(secureStorageProvider),
  );
});

final userAddInfoDataSourceProvider = Provider<UserAddInfoRemoteDataSource>((
  ref,
) {
  return UserAddInfoRemoteDataSource(ref.watch(firestoreProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authDataSourceProvider),
    ref.watch(userAddInfoDataSourceProvider),
  );
});

class AuthNotifier extends StateNotifier<AuthModel?> {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _storage;

  AuthNotifier(this._authRepository, this._storage) : super(null) {
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    final autoLogin = await _storage.read(key: 'useAutoLogin');

    if (autoLogin == 'true') {
      state = _authRepository.currentUser();
    }
  }

  Future<AuthModel> signIn({
    required String email,
    required String password,
  }) async {
    final result = await _authRepository.signIn(email, password);
    // 미인증·실패는 로그인 상태로 두지 않는다.
    state = result.authResultCode == '00' ? result : null;
    return result;
  }

  Future<AuthModel> signUp({
    required String email,
    required String password,
    required String nickname,
  }) async {
    try {
      final result = await _authRepository.signUp(
        email: email,
        password: password,
        nickname: nickname,
      );
      // 가입 후 인증 메일·signOut까지 끝나면 로그인 상태가 아니다.
      state = result.authResultCode == '00' ? null : result;
      return result;
    } catch (e) {
      final failed = AuthModel(
        authResultCode: '99',
        authResultMsg: '회원가입 중 오류가 발생했습니다: $e',
      );
      state = failed;
      return failed;
    }
  }

  AuthModel? logout(AuthModel auth) {
    state = null;
    _storage.delete(key: 'useAutoLogin');

    print('rlog :: 로그아웃 성공');
    return state;
  }
}
