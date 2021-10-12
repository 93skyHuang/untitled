import 'package:json_annotation/json_annotation.dart';

part 'user_basic.g.dart';

@JsonSerializable()
class UserBasic {
  // * headImgUrl [用户头像]
  // * cname [昵称]
  // * sex [性别 1-男，2-女]
  // * birthday [生日]
  // * height [身高]
  // * region [区域]
  // * constellation [星座]
  // * uid [用户ID]
  // * age [年龄]
  // * followSum [粉丝个数]
  // * trendsSum [动态条数]
  // * followSum [被关注次数]
  // * userdata [择偶标准]
  // * hobby [兴趣爱好]
  // * isVideo [视频是否已经认证 0-否，1-是]
  // * isHead [头像是否已经认证 0-否，1-是]
  // * isCard [身份证是否已认证 0-否，1-是]
  // * trendsList [动态列表]列表内容参照动态列表
  // * commentList [评论列表]
  // * time [发布时间]
  String? headImgUrl = '';
  String? cname = '';
  int? sex = 1;
  String? birthday = '';
  int? height ;
  String? constellation = '';
  int uid = 0;
  int? age = 0;
  int? followSum = 0;
  int? trendsSum = 0;
  // int? followSum = 0;
  String? userdata = '';
  List<String?> hobby =[];
  int? isVideo;
  int? isHead;
  int? isCard;
  List<String?> trendsList =[];
  List<String?> commentList =[];
  String? time = '';

  UserBasic();
  factory UserBasic.fromJson(Map<String, dynamic> json) => _$UserBasicFromJson(json);

  Map<String?, dynamic> toJson() => _$UserBasicToJson(this);
}
