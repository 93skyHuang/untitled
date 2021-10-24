// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitor_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitorInfo _$VisitorInfoFromJson(Map<String, dynamic> json) {
  return VisitorInfo()
    ..id = json['id'] as int
    ..uid = json['uid'] as int?
    ..headImgUrl = json['headImgUrl'] as String?
    ..cname = json['cname'] as String?
    ..height = json['height'] as int?
    ..age = json['age'] as int?
    ..time = json['time'] as String?
    ..region = json['region'] as String?
    ..constellation = json['constellation'] as String?;
}

Map<String, dynamic> _$VisitorInfoToJson(VisitorInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'headImgUrl': instance.headImgUrl,
      'cname': instance.cname,
      'height': instance.height,
      'age': instance.age,
      'time': instance.time,
      'region': instance.region,
      'constellation': instance.constellation,
    };
