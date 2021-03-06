import 'package:json_annotation/json_annotation.dart';

part 'pay_time.g.dart';

///用户月卡到期时间
@JsonSerializable()
class PayTime {
  int svip=0;
  String? svipEndTime;

  PayTime();
  factory PayTime.fromJson(Map<String, dynamic> json) => _$PayTimeFromJson(json);

  Map<String?, dynamic> toJson() => _$PayTimeToJson(this);
}
