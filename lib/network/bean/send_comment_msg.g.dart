// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_comment_msg.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendCommentMsg _$SendCommentMsgFromJson(Map<String, dynamic> json) =>
    SendCommentMsg()
      ..id = json['id'] as int
      ..isRead = json['isRead'] as int
      ..trendsId = json['trendsId'] as int?
      ..headImgUrl = json['headImgUrl'] as String?
      ..cname = json['cname'] as String?
      ..trendsContent = json['trendsContent'] as String?
      ..date = json['date'] as String?
      ..thisContent = json['thisContent'] == null
          ? null
          : DynamicContent.fromJson(
              json['thisContent'] as Map<String, dynamic>);

Map<String, dynamic> _$SendCommentMsgToJson(SendCommentMsg instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isRead': instance.isRead,
      'trendsId': instance.trendsId,
      'headImgUrl': instance.headImgUrl,
      'cname': instance.cname,
      'trendsContent': instance.trendsContent,
      'date': instance.date,
      'thisContent': instance.thisContent,
    };
