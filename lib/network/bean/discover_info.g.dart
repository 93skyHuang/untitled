// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscoverInfo _$DiscoverInfoFromJson(Map<String, dynamic> json) => DiscoverInfo()
  ..cname = json['cname'] as String?
  ..height = json['height'] as int?
  ..constellation = json['constellation'] as String?
  ..userLabel = json['userLabel'] as int?
  ..age = json['age'] as int?
  ..region = json['region'] as String?
  ..autograph = json['autograph'] as String?;

Map<String, dynamic> _$DiscoverInfoToJson(DiscoverInfo instance) =>
    <String, dynamic>{
      'cname': instance.cname,
      'height': instance.height,
      'constellation': instance.constellation,
      'userLabel': instance.userLabel,
      'age': instance.age,
      'region': instance.region,
      'autograph': instance.autograph,
    };