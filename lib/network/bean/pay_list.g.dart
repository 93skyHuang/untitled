// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

part of 'pay_list.dart';

PayList _$PayListFromJson(Map<String, dynamic> json) => PayList()
  ..headImgUrl = json['headImgUrl'] as String?
  ..cname = json['cname'] as String?
  ..svip = json['svip'] as int?
  ..monthlyCardList = (json['monthlyCardList'] as List<dynamic>)
      .map((e) => e as String?)
      .toList();

Map<String, dynamic> _$PayListToJson(PayList instance) => <String, dynamic>{
      'headImgUrl': instance.headImgUrl,
      'cname': instance.cname,
      'monthlyCardList': instance.monthlyCardList,
      'svip': instance.svip,
    };
