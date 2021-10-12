// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cover_follow_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoverFollowInfo _$CoverFollowInfoFromJson(Map<String, dynamic> json) =>
    CoverFollowInfo()
      ..id = json['id'] as int
      ..time = json['time'] as String?
      ..phone = json['phone'] as int?
      ..uid = json['uid'] as int?
      ..headImgUrl = json['headImgUrl'] as String?
      ..cname = json['cname'] as String?
      ..height = json['height'] as int?
      ..constellation = json['constellation'] as String?
      ..age = json['age'] as int?
      ..region = json['region'] as String?
      ..province = json['province'] as String?
      ..birthday = json['birthday'] as String?
      ..distance = json['distance'] as String?
      ..isFollow = json['isFollow'] as int;

Map<String, dynamic> _$CoverFollowInfoToJson(CoverFollowInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time,
      'phone': instance.phone,
      'uid': instance.uid,
      'headImgUrl': instance.headImgUrl,
      'cname': instance.cname,
      'height': instance.height,
      'constellation': instance.constellation,
      'age': instance.age,
      'region': instance.region,
      'province': instance.province,
      'birthday': instance.birthday,
      'distance': instance.distance,
      'isFollow': instance.isFollow,
    };
