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
    ..region = json['region'] as String?
    ..autograph = json['autograph'] as String?
    ..uid = json['uid'] as int
    ..age = json['age'] as int?
    ..followSum = json['followSum'] as int?
    ..trendsSum = json['trendsSum'] as int?
    ..pasDaySum = json['pasDaySum'] as int?
    ..dataPerfection = json['dataPerfection'] as int?
    ..userdata = json['userdata'] == null
        ? null
        : UserData.fromJson(json['userdata'] as Map<String, dynamic>)
    ..isVideo = json['isVideo'] as int?
    ..isHead = json['isHead'] as int?
    ..isCard = json['isCard'] as int?
    ..isFollow = json['isFollow'] as int?
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
      'dataPerfection': instance.dataPerfection,
      'age': instance.age,
      'followSum': instance.followSum,
      'trendsSum': instance.trendsSum,
      'userdata': instance.userdata,
      'isVideo': instance.isVideo,
      'isHead': instance.isHead,
      'isCard': instance.isCard,
      'isFollow': instance.isFollow,
      'trendsList': instance.trendsList,
      'commentList': instance.commentList,
      'time': instance.time,
      'svip': instance.svip,
      'region': instance.region,
      'autograph': instance.autograph,
      'pasDaySum': instance.pasDaySum,
    };

Trends _$TrendsFromJson(Map<String, dynamic> json) {
  return Trends()
    ..id = json['id'] as int
    ..isTrendsFabulous = json['isTrendsFabulous'] as int?
    ..type = json['type'] as int
    ..fabulousSum = json['fabulousSum'] as int
    ..beClickedSum = json['beClickedSum'] as int
    ..commentSum = json['commentSum'] as int
    ..video = json['video'] as String?
    ..content = json['content'] as String?
    ..time = json['time'] as String?
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
      'time': instance.time,
      'imgArr': instance.imgArr,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData()
    ..expectAge = json['expectAge'] as String?
    ..expectRegion = json['expectRegion'] as String?
    ..expectConstellation = json['expectConstellation'] as String?
    ..expectType = json['expectType'] as String?
    ..expectHeight = json['expectHeight'] as String?;
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'expectAge': instance.expectAge,
      'expectRegion': instance.expectRegion,
      'expectConstellation': instance.expectConstellation,
      'expectType': instance.expectType,
      'expectHeight': instance.expectHeight,
    };
