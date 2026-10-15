import 'package:baroallgi/core/const/const_code.dart';
import 'package:baroallgi/core/network/models/base_response.dart';
import 'package:baroallgi/features/auth/models/user_add_info_model.dart';
import 'package:baroallgi/features/auth/models/user_model.dart';

class AuthModel extends BaseResponse<UserModel> {
  final String authResultCode;
  final String authStatusCode;
  final String? authResultMsg;
  final UserModel? userModel;
  final UserAddInfoModel? userAddInfo;

  AuthModel({
    required this.authResultCode,
    this.authStatusCode = AUTH_STATUS_LOGOUT,
    this.authResultMsg,
    this.userModel,
    this.userAddInfo,
  }) : super(
         resultCode: authResultCode,
         resultMsg: authResultMsg,
         data: userModel,
       );
}
