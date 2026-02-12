import 'package:baroallgi/core/const/const_code.dart';
import 'package:baroallgi/core/network/models/base_response.dart';
import 'package:baroallgi/features/auth/models/user_model.dart';

class AuthModel extends BaseResponse<UserModel> {

  final String authResultCode;
  final String authStatusCode;
  final String? authResultMsg;
  final UserModel? userModel;



  AuthModel({
    required this.authResultCode,
    this.authStatusCode = AUTH_STATUS_LOGOUT, // 기본 세팅 로그아웃 상태
    this.authResultMsg,
    this.userModel,
    // userModel 추가
  }) : super(
         resultCode: authResultCode,
         resultMsg: authResultMsg,
         data: userModel,
         // userModel 추가
       );
}
