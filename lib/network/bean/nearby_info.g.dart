// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearbyInfo _$NearbyInfoFromJson(Map<String, dynamic> json) => NearbyInfo()
  ..cname = json['cname'] as String?
  ..headImgUrl = json['headImgUrl'] as String?
  ..distance = json['distance'] as String?
  ..height = json['height'] as int?
  ..region = json['region'] as String?
  ..autograph = json['autograph'] as String?
  ..constellation = json['constellation'] as String?
  ..loginTime = json['loginTime'] as String?
  ..userLabel = json['userLabel'] as int?
  ..age = json['age'] as int?
  ..trendsImg = (json['trendsImg'] as List<dynamic>)
      .map((e) =>
          e == null ? null : TrendsImg.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$NearbyInfoToJson(NearbyInfo instance) =>
    <String, dynamic>{
      'cname': instance.cname,
      'height': instance.height,
      'region': instance.region,
      'autograph': instance.autograph,
      'constellation': instance.constellation,
      'loginTime': instance.loginTime,
      'userLabel': instance.userLabel,
      'age': instance.age,
      'trendsImg': instance.trendsImg,
    };

TrendsImg _$TrendsImgFromJson(Map<String, dynamic> json) => TrendsImg()
  ..video = json['video'] as String?
  ..type = json['type'] as int?
  ..id = json['id'] as int?
  ..imgArr =
      (json['imgArr'] as List<dynamic>?)?.map((e) => e as String?).toList();

Map<String, dynamic> _$TrendsImgToJson(TrendsImg instance) => <String, dynamic>{
      'video': instance.video,
      'type': instance.type,
      'id': instance.id,
      'imgArr': instance.imgArr,
    };
