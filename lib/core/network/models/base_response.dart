import 'package:dio/dio.dart';

class BaseResponse<T> {
  final String resultCode;
  final String? resultMsg;
  final T? data;

  BaseResponse({required this.resultCode, this.resultMsg, this.data});

  bool get isSuccess => resultCode == '00';
}
