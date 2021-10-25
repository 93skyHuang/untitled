import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  // ** orderId [充值订单号]

  int orderId ;
  Order(this.orderId);
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String?, dynamic> toJson() => _$OrderToJson(this);
}
