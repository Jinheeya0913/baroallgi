import 'package:baroallgi/core/const/const_code.dart';
import 'package:baroallgi/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:baroallgi/features/auth/data/repositories/auth_repository.dart';
import 'package:baroallgi/features/auth/models/auth_model.dart';
import 'package:baroallgi/features/auth/models/user_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 1. firebase instance provider
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

// 2. data source provider
final authDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(firebaseAuthProvider));
});

// 3. Repository Provider (화면단에서만 보는 프로바이더)
final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  return AuthRepositoryImpl(ref.watch(authDataSourceProvider));
});

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<AuthModel> signIn(String email, String password) async {
    try {
      final credential = await _dataSource.signIn(email, password);
      print('rlog :: ${credential.user!.toString()}');
      return AuthModel(authResultCode: '00', authStatusCode: AUTH_STATUS_LOGIN,userModel: UserModel.fromFirebase(credential.user!));
    } on FirebaseAuthException catch (fe) {
      String? errorMsg;
      if (fe.code == 'user-not-found' || fe.code == 'wrong-password' || fe.code == 'invalid-credential') {
        errorMsg = '이메일 또는 비밀번호가 일치하지 않습니다.';
      } else {
        print('rlog :: 기타오류 ${fe.message}');
      }
      return AuthModel(authResultCode: '99', authResultMsg: errorMsg);
    } catch (e) {

      return AuthModel(
        authResultCode: '99',
        authResultMsg: '기타 에러. 관리자에게 문의하세요',
      );
    }
  }

  @override
  Future<AuthModel> signUp(String email, String password) async {
    try {
      final result = await _dataSource.signUp(email, password);
      UserModel? userInfo;
      if (result.user != null) {
        userInfo = UserModel.fromFirebase(result.user!);
      }

      return AuthModel(
        authResultCode: '00',
        authResultMsg: '회원가입 성공',
        userModel: userInfo,
      );

    } on FirebaseAuthException catch (fe) {
      return AuthModel(authResultCode: '99', authResultMsg: fe.message);
    } catch (e) {
      print('rlog :: 로그인 중 치명적인 에러 발생');
      throw UnimplementedError();
    }
  }
}
