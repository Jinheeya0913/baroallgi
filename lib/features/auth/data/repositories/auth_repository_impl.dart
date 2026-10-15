import 'package:baroallgi/core/const/const_code.dart';
import 'package:baroallgi/features/auth/auth_firebase_codes.dart';
import 'package:baroallgi/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:baroallgi/features/auth/data/datasources/user_add_info_remote_datasource.dart';
import 'package:baroallgi/features/auth/data/repositories/auth_repository.dart';
import 'package:baroallgi/features/auth/models/auth_model.dart';
import 'package:baroallgi/features/auth/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authDataSource;
  final UserAddInfoRemoteDataSource _addInfoDataSource;

  AuthRepositoryImpl(this._authDataSource, this._addInfoDataSource);

  static const _unverifiedLoginMessage =
      '이메일 인증 후 로그인할 수 있습니다. 인증 메일을 확인해주세요.';

  @override
  Future<AuthModel> signIn(String email, String password) async {
    try {
      final credential = await _authDataSource.signIn(email, password);
      print('rlog :: ${credential.user!.toString()}');

      await _authDataSource.reloadCurrentUser();
      final user = _authDataSource.currentUser();
      if (user == null) {
        return AuthModel(
          authResultCode: '99',
          authResultMsg: '로그인에 실패했습니다.',
        );
      }

      if (!user.emailVerified) {
        try {
          await _authDataSource.sendEmailVerification();
        } catch (e) {
          print('rlog :: 미인증 로그인 시 인증 메일 재발송 실패: $e');
        }
        await _authDataSource.signOut();
        return AuthModel(
          authResultCode: '99',
          authResultMsg: _unverifiedLoginMessage,
        );
      }

      final userModel = UserModel.fromFirebase(user);
      final addInfo = await _addInfoDataSource.fetch(userModel.uid);
      return AuthModel(
        authResultCode: '00',
        authStatusCode: AUTH_STATUS_LOGIN,
        userModel: userModel,
        userAddInfo: addInfo,
      );
    } on FirebaseAuthException catch (fe) {
      String? errorMsg;
      if (AuthFirebaseCodes.credentialMismatchCodes.contains(fe.code)) {
        errorMsg = '이메일 또는 비밀번호가 일치하지 않습니다.';
      } else {
        print('rlog :: 기타오류 ${fe.message}');
        errorMsg = fe.message;
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
  AuthModel? currentUser() {
    final user = _authDataSource.currentUser();
    if (user == null) return null;

    // 미인증이면 자동 로그인을 허용하지 않는다.
    if (!user.emailVerified) {
      _authDataSource.signOut();
      return null;
    }

    return AuthModel(
      authResultCode: '00',
      authStatusCode: AUTH_STATUS_LOGIN,
      userModel: UserModel.fromFirebase(user),
    );
  }

  @override
  Future<AuthModel?> loadCurrentUser() async {
    final user = _authDataSource.currentUser();
    if (user == null) return null;

    if (!user.emailVerified) {
      await _authDataSource.signOut();
      return null;
    }

    final userModel = UserModel.fromFirebase(user);
    final addInfo = await _addInfoDataSource.fetch(userModel.uid);
    return AuthModel(
      authResultCode: '00',
      authStatusCode: AUTH_STATUS_LOGIN,
      userModel: userModel,
      userAddInfo: addInfo,
    );
  }

  @override
  Future<AuthModel> signUp({
    required String email,
    required String password,
    required String nickname,
  }) async {
    try {
      final credential = await _authDataSource.signUp(email.trim(), password);
      final user = credential.user;
      if (user == null) {
        return AuthModel(
          authResultCode: '99',
          authResultMsg: '회원가입에 실패했습니다.',
        );
      }

      final addInfo = await _addInfoDataSource.createFreeAddInfo(
        uid: user.uid,
        nickname: nickname,
      );

      // addInfo까지 성공한 뒤 인증 메일을 보낸다. 실패해도 계정은 유지한다.
      var verificationSent = true;
      try {
        await _authDataSource.sendEmailVerification();
      } catch (e) {
        verificationSent = false;
        print('rlog :: 인증 메일 발송 실패: $e');
      }

      // 이메일 인증 전에는 로그인 세션을 유지하지 않는다.
      await _authDataSource.signOut();

      return AuthModel(
        authResultCode: '00',
        authResultMsg: verificationSent
            ? '인증 메일을 보냈습니다. 메일 확인 후 로그인해주세요.'
            : '가입은 완료됐지만 인증 메일 발송에 실패했습니다. 로그인 화면에서 다시 요청해주세요.',
        authStatusCode: AUTH_STATUS_LOGOUT,
        userModel: null,
        userAddInfo: addInfo,
      );
    } on FirebaseAuthException catch (fe) {
      return AuthModel(
        authResultCode: '99',
        authResultMsg: _signUpAuthErrorMessage(fe),
      );
    } catch (e) {
      print('rlog :: 회원가입 중 Firestore 오류: $e');
      try {
        await _authDataSource.deleteCurrentUser();
      } catch (deleteError) {
        print('rlog :: Auth 롤백 실패: $deleteError');
      }
      return AuthModel(
        authResultCode: '99',
        authResultMsg: '회원 추가정보 저장에 실패했습니다. 다시 시도해주세요.',
      );
    }
  }

  String _signUpAuthErrorMessage(FirebaseAuthException fe) {
    switch (fe.code) {
      case AuthFirebaseCodes.emailAlreadyInUse:
        return '이미 사용 중인 이메일입니다.';
      case AuthFirebaseCodes.invalidEmail:
        return '올바른 이메일 형식이 아닙니다.';
      case AuthFirebaseCodes.weakPassword:
        return '비밀번호는 6자 이상이어야 합니다.';
      case AuthFirebaseCodes.operationNotAllowed:
        return '이메일 가입이 비활성화되어 있습니다.';
      default:
        return fe.message ?? '회원가입에 실패했습니다.';
    }
  }
}
