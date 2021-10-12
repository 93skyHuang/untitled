// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_basic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBasic _$UserBasicFromJson(Map<String, dynamic> json) => UserBasic()
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
  // ..trendsSum = json['trendsSum'] as int?
  ..userdata = json['userdata'] as String?
  ..hobby = (json['hobby'] as List<dynamic>).map((e) => e as String?).toList()
  ..isVideo = json['isVideo'] as int?
  ..isHead = json['isHead'] as int?
  ..isCard = json['isCard'] as int?
  ..trendsList =
      (json['trendsList'] as List<dynamic>).map((e) => e as String?).toList()
  ..commentList =
      (json['commentList'] as List<dynamic>).map((e) => e as String?).toList()
  ..time = json['time'] as String?;

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
      // 'followSum': instance.followSum,
      'userdata': instance.userdata,
      'hobby': instance.hobby,
      'isVideo': instance.isVideo,
      'isHead': instance.isHead,
      'isCard': instance.isCard,
      'trendsList': instance.trendsList,
      'commentList': instance.commentList,
      'time': instance.time,
    };
