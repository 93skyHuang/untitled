// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUserInfo _$ChatUserInfoFromJson(Map<String, dynamic> json) => ChatUserInfo()
  ..uid = json['uid'] as int
  ..headImgUrl = json['headImgUrl'] as String?
  ..cname = json['cname'] as String?
  ..height = json['height'] as int?
  ..constellation = json['constellation'] as String?
  ..age = json['age'] as int?
  ..sex = json['sex'] as int?
  ..region = json['region'] as String?
  ..autograph = json['autograph'] as String?
  ..birthday = json['birthday'] as String?
  ..backgroundImage = json['backgroundImage'] as String?
  ..svipEndTime = json['svipEndTime'] as int?
  ..expectAge = json['expectAge'] as String?
  ..expectHeight = json['expectHeight'] as String?
  ..expectConstellation = json['expectConstellation'] as String?
  ..expectType = json['expectType'] as String?
  ..isVideo = json['isVideo'] as int?
  ..svip = json['svip'] as int?
  ..vip = json['vip'] as int?
  ..isPhone = json['isPhone'] as int?
  ..isCard = json['isCard'] as int?
  ..isHead = json['isHead'] as int?
  ..trendsList = (json['trendsList'] as List<dynamic>?)
      ?.map((e) => Trends.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ChatUserInfoToJson(ChatUserInfo instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'headImgUrl': instance.headImgUrl,
      'cname': instance.cname,
      'height': instance.height,
      'constellation': instance.constellation,
      'age': instance.age,
      'sex': instance.sex,
      'region': instance.region,
      'autograph': instance.autograph,
      'birthday': instance.birthday,
      'backgroundImage': instance.backgroundImage,
      'svipEndTime': instance.svipEndTime,
      'expectAge': instance.expectAge,
      'expectHeight': instance.expectHeight,
      'expectConstellation': instance.expectConstellation,
      'expectType': instance.expectType,
      'isVideo': instance.isVideo,
      'svip': instance.svip,
      'vip': instance.vip,
      'isPhone': instance.isPhone,
      'isCard': instance.isCard,
      'isHead': instance.isHead,
      'trendsList': instance.trendsList,
    };

Trends _$TrendsFromJson(Map<String, dynamic> json) => Trends(
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
