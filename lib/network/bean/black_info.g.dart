// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'black_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlackInfo _$BlackInfoFromJson(Map<String, dynamic> json) => BlackInfo()
  ..id = json['id'] as int
  ..uid = json['uid'] as int?
  ..headImgUrl = json['headImgUrl'] as String?
  ..cname = json['cname'] as String?
  ..autograph = json['autograph'] as String?
  ..date = json['date'] as String?;

Map<String, dynamic> _$BlackInfoToJson(BlackInfo instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'headImgUrl': instance.headImgUrl,
      'cname': instance.cname,
      'autograph': instance.autograph,
      'date': instance.date,
    };
