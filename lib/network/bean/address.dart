import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  Address({
    this.province = '',
    this.region = '',
  });

  String province;

  String region;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}
