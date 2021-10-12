import 'package:json_annotation/json_annotation.dart';

part 'chat_user_info.g.dart';

/**
 * 聊天对方用户信息
 */
@JsonSerializable()
class ChatUserInfo {

  int uid = 0;
  String? headImgUrl = '';
  String? cname = '';
  int? height;

  String? constellation = '';
  int? age = 0;
  int? sex = 1;
  String? region = '';
  String? autograph = '';
  String? birthday = '';
  String? backgroundImage = '';

  int? svipEndTime;
  String? expectAge = '';
  String? expectHeight = '';
  String? expectConstellation = '';
  String? expectType = '';

  /// 0-否，1-是]
  int? isVideo;
  int? svip;
  int? vip;
  int? isPhone;
  int? isCard;
  int? isHead;
  List<Trends>? trendsList;///对方动态列表

  ChatUserInfo();

  factory ChatUserInfo.fromJson(Map<String, dynamic> json) =>
      _$ChatUserInfoFromJson(json);

  Map<String?, dynamic> toJson() => _$ChatUserInfoToJson(this);
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
  List<String>? imgArr;

  Trends(this.id, this.type);

  factory Trends.fromJson(Map<String, dynamic> json) =>
      _$TrendsFromJson(json);

  Map<String?, dynamic> toJson() => _$TrendsToJson(this);
}
