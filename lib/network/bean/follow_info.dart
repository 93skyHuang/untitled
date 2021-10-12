import 'package:json_annotation/json_annotation.dart';

part 'follow_info.g.dart';

///关注信息
@JsonSerializable()
class FollowInfo {
  // * id [主键ID，删除时传给后台]
  // * time [时间]
  // * phone [手机号]
  // * uid [对方UID]
  // * cname [对方昵称]
  // * headImgUrl [头像]
  // * height [身高]
  // * constellation [星座]
  // * age [年龄]
  // * province [省]
  // * region [市]
  // * distance [距离]

  int id = -1;

  String? time;
  int? phone;

  int? uid;
  String? headImgUrl = '';
  String? cname = '';
  int? height;

  String? constellation = '';
  int? age = 0;
  String? region = '';
  String? province = '';
  String? birthday = '';
  String? distance = '';

  FollowInfo();

  factory FollowInfo.fromJson(Map<String, dynamic> json) =>
      _$FollowInfoFromJson(json);

  Map<String?, dynamic> toJson() => _$FollowInfoToJson(this);
}
