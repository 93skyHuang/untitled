// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_trends_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewTrendsInfo _$NewTrendsInfoFromJson(Map<String, dynamic> json) =>
    NewTrendsInfo()
      ..uid = json['uid'] as int
      ..sex = json['sex'] as int?
      ..headImgUrl = json['headImgUrl'] as String?
      ..cname = json['cname'] as String?
      ..height = json['height'] as int?
      ..constellation = json['constellation'] as String?
      ..age = json['age'] as int?
      ..trendsId = json['trendsId'] as int?
      ..region = json['region'] as String?
      ..video = json['video'] as String?
      ..content = json['content'] as String?
      ..imgArr =
          (json['imgArr'] as List<dynamic>).map((e) => e as String?).toList()
      ..trendsFabulousList = (json['trendsFabulousList'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList()
      ..commentList = (json['commentList'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList()
      ..fabulousSum = json['fabulousSum'] as int?
      ..commentSum = json['commentSum'] as int?
      ..beClickedSum = json['beClickedSum'] as int?
      ..isFollow = json['isFollow'] as int?
      ..time = json['time'] as String?
      ..area = json['area'] as String?
      ..type = json['type'] as int?
      ..isTrendsFabulous = json['isTrendsFabulous'] as int?
      ..userLabel = json['userLabel'] as int?;

Map<String, dynamic> _$NewTrendsInfoToJson(NewTrendsInfo instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'sex': instance.sex,
      'headImgUrl': instance.headImgUrl,
      'cname': instance.cname,
      'height': instance.height,
      'constellation': instance.constellation,
      'age': instance.age,
      'trendsId': instance.trendsId,
      'region': instance.region,
      'video': instance.video,
      'content': instance.content,
      'imgArr': instance.imgArr,
      'trendsFabulousList': instance.trendsFabulousList,
      'commentList': instance.commentList,
      'fabulousSum': instance.fabulousSum,
      'commentSum': instance.commentSum,
      'beClickedSum': instance.beClickedSum,
      'time': instance.time,
      'area': instance.area,
      'type': instance.type,
      'isTrendsFabulous': instance.isTrendsFabulous,
      'userLabel': instance.userLabel,
    };
