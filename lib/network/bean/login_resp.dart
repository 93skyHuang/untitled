import 'package:json_annotation/json_annotation.dart';

part 'login_resp.g.dart';

@JsonSerializable()
class LoginResp {
  LoginResp();
  int uid = 0;
  int sex = 1;
  int svip = 0;
  int? isNewUser = 0;
  String? loginToken = '';

  factory LoginResp.fromJson(Map<String, dynamic> json) =>
      _$LoginRespFromJson(json);

}
