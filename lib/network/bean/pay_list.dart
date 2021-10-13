import 'package:json_annotation/json_annotation.dart';

part 'pay_list.g.dart';

@JsonSerializable()
class PayList {
  // * headImgUrl [头像]
  // * cname [昵称]
  // * svip [月卡状态]
  // * monthlyCardList [月卡列表]

  String? headImgUrl = '';
  String? cname = '';
  int? svip;
  List<MonthlyCard?>? monthlyCardList;

  PayList();

  factory PayList.fromJson(Map<String, dynamic> json) =>
      _$PayListFromJson(json);

  Map<String?, dynamic> toJson() => _$PayListToJson(this);
}

@JsonSerializable()
class MonthlyCard {

  String? describe;
  String? money;
  String? iosKey;//内购标识 就是账号上的支付唯一标识
  String? text1;
  String? text2;
  String? text3;
  String? text4;

  MonthlyCard();

  factory MonthlyCard.fromJson(Map<String, dynamic> json) =>
      _$MonthlyCardFromJson(json);

  Map<String?, dynamic> toJson() => _$MonthlyCardToJson(this);
}
