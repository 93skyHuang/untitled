// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo()
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
    ..isVideo = json['isVideo'] as int?
    ..svip = json['svip'] as int?
    ..vip = json['vip'] as int?
    ..svipEndTime = json['svipEndTime'] as String?
    ..expectAge = json['expectAge'] as String?
    ..expectHeight = json['expectHeight'] as String?
    ..expectConstellation = json['expectConstellation'] as String?
    ..expectType = json['expectType'] as String?
    ..expectRegion = json['expectRegion'] as String?
    ..hobby =
        (json['hobby'] as List<dynamic>?)?.map((e) => e as String).toList();
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
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
      'isVideo': instance.isVideo,
      'svip': instance.svip,
      'vip': instance.vip,
      'svipEndTime': instance.svipEndTime,
      'expectAge': instance.expectAge,
      'expectHeight': instance.expectHeight,
      'expectConstellation': instance.expectConstellation,
      'expectType': instance.expectType,
      'expectRegion': instance.expectRegion,
      'hobby': instance.hobby,
    };
