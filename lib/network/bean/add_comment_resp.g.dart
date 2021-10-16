// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_comment_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddCommentResp _$AddCommentRespFromJson(Map<String, dynamic> json) {
  return AddCommentResp()
    ..id = json['id'] as int
    ..uid = json['uid'] as int
    ..trendsId = json['trendsId'] as int?
    ..content = json['content'] as String?
    ..cname = json['cname'] as String?
    ..headImgUrl = json['headImgUrl'] as String?
    ..fabulousSum = json['fabulousSum'] as int?
    ..replySum = json['replySum'] as int?
    ..time = json['time'] as String?
    ..isFabulous = json['isFabulous'] as int?;
}

Map<String, dynamic> _$AddCommentRespToJson(AddCommentResp instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'trendsId': instance.trendsId,
      'content': instance.content,
      'cname': instance.cname,
      'headImgUrl': instance.headImgUrl,
      'fabulousSum': instance.fabulousSum,
      'replySum': instance.replySum,
      'time': instance.time,
      'isFabulous': instance.isFabulous,
    };
