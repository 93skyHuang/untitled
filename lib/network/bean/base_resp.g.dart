// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResp _$BaseRespFromJson(Map<String, dynamic> json) => BaseResp(
      code: json['code'] as int,
      msg: json['msg'] as String,
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$BaseRespToJson(BaseResp instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
    };
