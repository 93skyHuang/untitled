// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receive_comment_msg.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiveCommentMsg _$ReceiveCommentMsgFromJson(Map<String, dynamic> json) {
  return ReceiveCommentMsg()
    ..id = json['id'] as int
    ..isRead = json['isRead'] as int
    ..trendsId = json['trendsId'] as int?
    ..headImgUrl = json['headImgUrl'] as String?
    ..cname = json['cname'] as String?
    ..trendsContent = json['trendsContent'] as String?
    ..date = json['date'] as String?
    ..thisContent = json['thisContent'] == null
        ? null
        : DynamicContent.fromJson(json['thisContent'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ReceiveCommentMsgToJson(ReceiveCommentMsg instance) =>
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
