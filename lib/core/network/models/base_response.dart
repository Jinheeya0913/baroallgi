import 'package:baroallgi/core/const/const_code.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  final String resultCode;
  final String? resultMsg;
  final T? data;

  BaseResponse({required this.resultCode, this.resultMsg, this.data});

  factory BaseResponse.successResult({T? data}) {
    return BaseResponse(
      resultCode: REQUEST_SUCCESS,
      resultMsg: '성공',
      data: data,
    );
  }

  factory BaseResponse.failResult({String? resultCode, String? resultMsg}) {
    return BaseResponse(
      resultCode: resultCode ?? '99',
      resultMsg: resultMsg ?? '실패',
    );
  }

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseResponseToJson(this, toJsonT);

  bool get isSuccess => resultCode == '00';
}
