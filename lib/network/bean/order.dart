import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  // ** orderId [充值订单号]

  String? orderId = '';
  Order();
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String?, dynamic> toJson() => _$OrderToJson(this);
}
