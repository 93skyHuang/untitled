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
  List<String?> monthlyCardList =[];
  PayList();
  factory PayList.fromJson(Map<String, dynamic> json) => _$PayListFromJson(json);

  Map<String?, dynamic> toJson() => _$PayListToJson(this);
}
