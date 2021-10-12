// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_fabulous_msg.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendFabulousMsg _$SendFabulousMsgFromJson(Map<String, dynamic> json) =>
    SendFabulousMsg()
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

Map<String, dynamic> _$SendFabulousMsgToJson(SendFabulousMsg instance) =>
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
