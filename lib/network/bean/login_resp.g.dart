// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResp _$LoginRespFromJson(Map<String, dynamic> json) {
  return LoginResp()
    ..uid = json['uid'] as int
    ..sex = json['sex'] as int
    ..loginToken = json['loginToken'] as String?;
}

Map<String, dynamic> _$LoginRespToJson(LoginResp instance) => <String, dynamic>{
      'uid': instance.uid,
      'sex': instance.sex,
      'loginToken': instance.loginToken,
    };
