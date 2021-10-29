// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearbyInfo _$NearbyInfoFromJson(Map<String, dynamic> json) {
  return NearbyInfo()
    ..cname = json['cname'] as String?
    ..education = json['education'] as String?
    ..headImgUrl = json['headImgUrl'] as String?
    ..distance = json['distance'] as String?
    ..height = json['height'] as int?
    ..uid = json['uid'] as int
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
}

Map<String, dynamic> _$NearbyInfoToJson(NearbyInfo instance) =>
    <String, dynamic>{
      'cname': instance.cname,
      'education': instance.education,
      'headImgUrl': instance.headImgUrl,
      'distance': instance.distance,
      'height': instance.height,
      'region': instance.region,
      'autograph': instance.autograph,
      'constellation': instance.constellation,
      'loginTime': instance.loginTime,
      'userLabel': instance.userLabel,
      'age': instance.age,
      'trendsImg': instance.trendsImg,
    };

TrendsImg _$TrendsImgFromJson(Map<String, dynamic> json) {
  return TrendsImg(
    json['id'] as int,
    json['type'] as int,
  )
    ..video = json['video'] as String?
    ..imgArr = json['imgArr'] as String;
}

Map<String, dynamic> _$TrendsImgToJson(TrendsImg instance) => <String, dynamic>{
      'video': instance.video,
      'type': instance.type,
      'id': instance.id,
      'imgArr': instance.imgArr,
    };
