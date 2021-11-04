// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trends_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrendsDetails _$TrendsDetailsFromJson(Map<String, dynamic> json) {
  return TrendsDetails()
    ..uid = json['uid'] as int
    ..id = json['id'] as int
    ..video = json['video'] as String?
    ..content = json['content'] as String?
    ..imgArr =
        (json['imgArr'] as List<dynamic>).map((e) => e as String?).toList()
    ..type = json['type'] as int?
    ..time = json['time'] as String?
    ..area = json['area'] as String?
    ..isTrendsFabulous = json['isTrendsFabulous'] as int?
    ..cname = json['cname'] as String?
    ..isfollow = json['isfollow'] as int?
    ..headImgUrl = json['headImgUrl'] as String?
    ..fabulousSum = json['fabulousSum'] as int?
    ..fabulousList = (json['fabulousList'] as List<dynamic>?)
        ?.map((e) => e as String?)
        .toList();
}

Map<String, dynamic> _$TrendsDetailsToJson(TrendsDetails instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'id': instance.id,
      'cname': instance.cname,
      'video': instance.video,
      'content': instance.content,
      'imgArr': instance.imgArr,
      'type': instance.type,
      'time': instance.time,
      'area': instance.area,
      'isfabulous': instance.isTrendsFabulous,
      'isfollow': instance.isfollow,
      'fabulousSum': instance.fabulousSum,
      'headImgUrl': instance.headImgUrl,
      'fabulousList': instance.fabulousList,
    };
