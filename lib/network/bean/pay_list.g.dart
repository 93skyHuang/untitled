// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayList _$PayListFromJson(Map<String, dynamic> json) {
  return PayList()
    ..headImgUrl = json['headImgUrl'] as String?
    ..cname = json['cname'] as String?
    ..svip = json['svip'] as int?
    ..monthlyCardList = (json['monthlyCardList'] as List<dynamic>?)
        ?.map((e) =>
            e == null ? null : MonthlyCard.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$PayListToJson(PayList instance) => <String, dynamic>{
      'headImgUrl': instance.headImgUrl,
      'cname': instance.cname,
      'svip': instance.svip,
      'monthlyCardList': instance.monthlyCardList,
    };

MonthlyCard _$MonthlyCardFromJson(Map<String, dynamic> json) {
  return MonthlyCard()
    ..describe = json['describe'] as String?
    ..money = json['money'] as String?
    ..iosKey = json['iosKey'] as String?
    ..text1 = json['text1'] as String?
    ..text2 = json['text2'] as String?
    ..text3 = json['text3'] as String?
    ..text4 = json['text4'] as String?;
}

Map<String, dynamic> _$MonthlyCardToJson(MonthlyCard instance) =>
    <String, dynamic>{
      'describe': instance.describe,
      'money': instance.money,
      'iosKey': instance.iosKey,
      'text1': instance.text1,
      'text2': instance.text2,
      'text3': instance.text3,
      'text4': instance.text4,
    };
