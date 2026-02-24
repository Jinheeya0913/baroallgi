import 'package:dio/dio.dart';

class BaseResponse<T> {
  final String resultCode;
  final String? resultMsg;
  final T? data;

  BaseResponse({required this.resultCode, this.resultMsg, this.data});

  factory  BaseResponse.successResult(T? data) {
    return BaseResponse(resultCode: '00', resultMsg: '성공', data: data);
  }

  factory  BaseResponse.failResult(String? resultCode, String? resultMsg) {
    return BaseResponse(resultCode: resultCode ?? '99', resultMsg: resultMsg ?? '실패');
  }

  bool get isSuccess => resultCode == '00';
}
