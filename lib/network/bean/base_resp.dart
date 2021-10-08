import 'package:json_annotation/json_annotation.dart';

part 'base_resp.g.dart';

@JsonSerializable()
class BaseResp {
  BaseResp({required this.code, required this.msg, this.data = const {'': ''}});

  final int code;

  final String msg;

  Map<String, dynamic> data;

  factory BaseResp.fromJson(Map<String, dynamic> json) =>
      _$BaseRespFromJson(json);

  Map<String?, dynamic> toJson() => _$BaseRespToJson(this);

  @override
  String toString() {
    return 'BaseResp code=$code  msg=$msg  data=${data.toString()}';
  }
}
