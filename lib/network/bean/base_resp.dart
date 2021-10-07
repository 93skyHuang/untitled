part 'base_resp.g.dart';


class BaseResp{
  BaseResp({required this.code, required this.msg,required this.data});

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
