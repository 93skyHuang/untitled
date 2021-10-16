// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResp _$BaseRespFromJson(Map<String, dynamic> json) {
  return BaseResp(
    code: json['code'] as int,
    msg: json['msg'] as String,
    data: json['data'],
  );
}

Map<String, dynamic> _$BaseRespToJson(BaseResp instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
    };
