// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_trends_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoTrendsInfo _$VideoTrendsInfoFromJson(Map<String, dynamic> json) {
  return VideoTrendsInfo()
    ..uid = json['uid'] as int
    ..sex = json['sex'] as int?
    ..headImgUrl = json['headImgUrl'] as String?
    ..cname = json['cname'] as String?
    ..height = json['height'] as int?
    ..constellation = json['constellation'] as String?
    ..age = json['age'] as int?
    ..region = json['region'] as String?
    ..trendsId = json['trendsId'] as int?
    ..video = json['video'] as String?
    ..content = json['content'] as String?
    ..imgArr = json['imgArr'] as String?
    ..fabulousSum = json['fabulousSum'] as int?
    ..commentSum = json['commentSum'] as int?
    ..beClickedSum = json['beClickedSum'] as int?
    ..time = json['time'] as String?
    ..type = json['type'] as int?
    ..area = json['area'] as String?
    ..commentList = (json['commentList'] as List<dynamic>?)
        ?.map((e) =>
            e == null ? null : CommentBean.fromJson(e as Map<String, dynamic>))
        .toList()
    ..isTrendsFabulous = json['isTrendsFabulous'] as int?
    ..trendsFabulousList = (json['trendsFabulousList'] as List<dynamic>?)
        ?.map((e) => e as String?)
        .toList()
    ..userLabel = json['userLabel'] as int?;
}

Map<String, dynamic> _$VideoTrendsInfoToJson(VideoTrendsInfo instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'sex': instance.sex,
      'headImgUrl': instance.headImgUrl,
      'cname': instance.cname,
      'height': instance.height,
      'constellation': instance.constellation,
      'age': instance.age,
      'region': instance.region,
      'trendsId': instance.trendsId,
      'video': instance.video,
      'content': instance.content,
      'imgArr': instance.imgArr,
      'fabulousSum': instance.fabulousSum,
      'commentSum': instance.commentSum,
      'beClickedSum': instance.beClickedSum,
      'time': instance.time,
      'type': instance.type,
      'area': instance.area,
      'commentList': instance.commentList,
      'isTrendsFabulous': instance.isTrendsFabulous,
      'trendsFabulousList': instance.trendsFabulousList,
      'userLabel': instance.userLabel,
    };
