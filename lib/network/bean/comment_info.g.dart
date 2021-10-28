// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentInfo _$CommentInfoFromJson(Map<String, dynamic> json) {
  return CommentInfo()
    ..id = json['id'] as int?
    ..uid = json['uid'] as int?
    ..content = json['content'] as String?
    ..cname = json['cname'] as String?
    ..headImgUrl = json['headImgUrl'] as String?
    ..fabulousSum = json['fabulousSum'] as int?
    ..replySum = json['replySum'] as int?
    ..isFabulous = json['isFabulous'] as int?;
}

Map<String, dynamic> _$CommentInfoToJson(CommentInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'content': instance.content,
      'cname': instance.cname,
      'fabulousSum': instance.fabulousSum,
      'replySum': instance.replySum,
      'isFabulous': instance.isFabulous,
      'headImgUrl': instance.headImgUrl,
    };
