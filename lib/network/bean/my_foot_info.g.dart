// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_foot_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyFootInfo _$MyFootInfoFromJson(Map<String, dynamic> json) {
  return MyFootInfo()
    ..uid = json['uid'] as int?
    ..age = json['age'] as int?
    ..height = json['height'] as int?
    ..headImgUrl = json['headImgUrl'] as String?
    ..region = json['region'] as String?
    ..cname = json['cname'] as String?
    ..constellation = json['constellation'] as String?
    ..time = json['time'] as String?;
}

Map<String, dynamic> _$MyFootInfoToJson(MyFootInfo instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'age': instance.age,
      'region': instance.region,
      'height': instance.height,
      'headImgUrl': instance.headImgUrl,
      'cname': instance.cname,
      'constellation': instance.constellation,
      'time': instance.time,
    };
