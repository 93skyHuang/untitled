import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInfo {
//* uid [用户UID]
//      * headImgUrl [头像]
//      * cname [昵称]
//      * height [身高]
//      * constellation [星座]
//      * age [年龄]
//      * sex [性别 1-男，2-女]
//      * region [区域]
//      * autograph [签名]
//      * birthday [生日]
//      * backgroundImage [用户主页背景图]
//      * isVideo [是否已视频认证，0-否，1-是]
//      * svip [是否是月卡用户0-否，1-是]
//      * svipEndTime [月卡到期时间0-否，1-是]
//      * expectAge [交友年龄]
//      * expectRegion [期望对象城市]
//      * expectHeight [期望对象身高]
//           * expectConstellation [期望对象星座]
//           * expectType [你在这里寻找什么]
//          * hobby [我的兴趣爱好]
  int uid = 0;
  String? headImgUrl = '';
  String? cname = '';
  int? height ;
  String? constellation = '';
  int? age = 0;
  int? sex = 1;
  String? region = '';
  String? autograph = '';
  String? birthday = '';
  String? backgroundImage = '';
  int? isVideo;
  int? svip;
  int? vip;
  String? svipEndTime;
  String? expectAge = '';
  String? expectHeight = '';
  String? expectConstellation = '';
  String? expectType = '';
  String? expectRegion = '';
  List<String>? hobby =[];

  UserInfo();
  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  Map<String?, dynamic> toJson() => _$UserInfoToJson(this);
}
