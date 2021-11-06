// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_fabulous_msg.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendFabulousMsg _$SendFabulousMsgFromJson(Map<String, dynamic> json) {
  return SendFabulousMsg()
    ..id = json['id'] as int
    ..uid = json['uid'] as int
    ..isRead = json['isRead'] as int
    ..trendsId = json['trendsId'] as int?
    ..headImgUrl = json['headImgUrl'] as String?
    ..cname = json['cname'] as String?
    ..trendsContent = json['trendsContent'] as String?
    ..date = json['date'] as String?
    ..age = json['age'] as int?
    ..constellation = json['constellation'] as String?
    ..region = json['region'] as String?
    // ..thisContent = json['thisContent'] == null
    //     ? null
    //     : DynamicContent.fromJson(json['thisContent'] as Map<String, dynamic>)
  ;
}

Map<String, dynamic> _$SendFabulousMsgToJson(SendFabulousMsg instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'isRead': instance.isRead,
      'trendsId': instance.trendsId,
      'headImgUrl': instance.headImgUrl,
      'age': instance.age,
      'cname': instance.cname,
      'trendsContent': instance.trendsContent,
      'date': instance.date,
      'constellation': instance.constellation,
      'region': instance.region,
      // 'thisContent': instance.thisContent,
    };
