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
  String? region = '';
  String? autograph = '';
  int uid = 0;
  int? age = 0;
  int? followSum = 0;
  int? trendsSum = 0;
  UserData? userdata ;
  int? isVideo;
  int? isHead;
  int? isCard;
  int? isFollow;
  List<Trends?>? trendsList;
  List<String?>? commentList;
  String? time ;
  int? svip;

  UserBasic();
  factory UserBasic.fromJson(Map<String, dynamic> json) => _$UserBasicFromJson(json);

  Map<String?, dynamic> toJson() => _$UserBasicToJson(this);
}

//动态信息
@JsonSerializable()
class Trends {
  ///[对方动态列表]id-动态ID,video-视频地址,content-动态内容,imgArr-动态图片集,fabulousSum-被赞次数,beClickedSum-被看次数,
  ///commentSum-被评论数,type-动态类型（0-心情（只有一段文字），1-动态（有文字和图片），2-视频）
  int id;
  int fabulousSum = 0;
  int beClickedSum = 0;
  int commentSum = 0;
  int type;
  String? video;
  String? content;
  List<String?>? imgArr;

  Trends(this.id, this.type);

  factory Trends.fromJson(Map<String, dynamic> json) =>
      _$TrendsFromJson(json);

  Map<String?, dynamic> toJson() => _$TrendsToJson(this);
}

//动态信息
@JsonSerializable()
class UserData {
  ///     * expectAge [交友年龄]
  //      * expectRegion [期望对象城市]
  //      * expectHeight [期望对象身高]
  //      * expectConstellation [期望对象星座]
  //      * expectType [你在这里寻找什么]
  //      * hobby [我的兴趣爱好](兴趣爱好以数组格式传递)
  String? expectAge;
  String? expectRegion;
  String? expectConstellation;
  String? expectType;
  String? expectHeight;
  int? isPhone;

  UserData();

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String?, dynamic> toJson() => _$UserDataToJson(this);
}
