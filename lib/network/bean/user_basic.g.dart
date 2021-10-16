// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_basic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBasic _$UserBasicFromJson(Map<String, dynamic> json) {
  return UserBasic()
    ..headImgUrl = json['headImgUrl'] as String?
    ..cname = json['cname'] as String?
    ..sex = json['sex'] as int?
    ..birthday = json['birthday'] as String?
    ..height = json['height'] as int?
    ..constellation = json['constellation'] as String?
    ..uid = json['uid'] as int
    ..age = json['age'] as int?
    ..followSum = json['followSum'] as int?
    ..trendsSum = json['trendsSum'] as int?
    ..userdata = json['userdata'] as String?
    ..hobby = (json['hobby'] as List<dynamic>).map((e) => e as String?).toList()
    ..isVideo = json['isVideo'] as int?
    ..isHead = json['isHead'] as int?
    ..isCard = json['isCard'] as int?
    ..trendsList = (json['trendsList'] as List<dynamic>?)
        ?.map((e) =>
            e == null ? null : Trends.fromJson(e as Map<String, dynamic>))
        .toList()
    ..commentList = (json['commentList'] as List<dynamic>?)
        ?.map((e) => e as String?)
        .toList()
    ..time = json['time'] as String?
    ..svip = json['svip'] as int?;
}

Map<String, dynamic> _$UserBasicToJson(UserBasic instance) => <String, dynamic>{
      'headImgUrl': instance.headImgUrl,
      'cname': instance.cname,
      'sex': instance.sex,
      'birthday': instance.birthday,
      'height': instance.height,
      'constellation': instance.constellation,
      'uid': instance.uid,
      'age': instance.age,
      'followSum': instance.followSum,
      'trendsSum': instance.trendsSum,
      'userdata': instance.userdata,
      'hobby': instance.hobby,
      'isVideo': instance.isVideo,
      'isHead': instance.isHead,
      'isCard': instance.isCard,
      'trendsList': instance.trendsList,
      'commentList': instance.commentList,
      'time': instance.time,
      'svip': instance.svip,
    };

Trends _$TrendsFromJson(Map<String, dynamic> json) {
  return Trends(
    json['id'] as int,
    json['type'] as int,
  )
    ..fabulousSum = json['fabulousSum'] as int
    ..beClickedSum = json['beClickedSum'] as int
    ..commentSum = json['commentSum'] as int
    ..video = json['video'] as String?
    ..content = json['content'] as String?
    ..imgArr =
        (json['imgArr'] as List<dynamic>?)?.map((e) => e as String).toList();
}

Map<String, dynamic> _$TrendsToJson(Trends instance) => <String, dynamic>{
      'id': instance.id,
      'fabulousSum': instance.fabulousSum,
      'beClickedSum': instance.beClickedSum,
      'commentSum': instance.commentSum,
      'type': instance.type,
      'video': instance.video,
      'content': instance.content,
      'imgArr': instance.imgArr,
    };
