import 'package:json_annotation/json_annotation.dart';

part 'discover_info.g.dart';

///发现页信息
@JsonSerializable()
class DiscoverInfo {
// * height [身高]
//  * region [市区]
//  * cname [发布者昵称]
//  * autograph [签名]
//  * age [年龄]
//  * constellation [星座]
//  * userLabel [用户标签]0-没有标签，3-视频认证，2-身份认证，1-头像认证

  String? cname;
  int uid=-1;
  int? height;

  String? constellation;
  String? headImgUrl;
  String loginTime='刚刚在线';

  int? userLabel;

  int? age = 0;
  String? region;

  String? autograph;

  DiscoverInfo();

  factory DiscoverInfo.fromJson(Map<String, dynamic> json) =>
      _$DiscoverInfoFromJson(json);

  Map<String?, dynamic> toJson() => _$DiscoverInfoToJson(this);
}
