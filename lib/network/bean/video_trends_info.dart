import 'package:json_annotation/json_annotation.dart';

part 'video_trends_info.g.dart';

///动态-视频
@JsonSerializable()
class VideoTrendsInfo {
  //  * uid [对方UID]
  //  * sex [性别]
  //  * headImgUrl [头像]
  //  * height [身高]
  //  * constellation [星座]
  //  * age [年龄]
  //  * region [区域]
  //  * trendsId [动态ID]
  //  * video [视频地址]
  //  * content [动态内容]
  //  * imgArr [动态图片]
  //  * fabulousSum [被赞次数]
  //  * commentSum [被评论次数]
  //  * beClickedSum [被查看次数]
  //  * time [时间]
  //  * type [动态类型0-心情（只有一段文字），1-动态（有文字和图片），2-视频]
  //  * area [区域]
  //  * commentList [评论列表]
  //  * isTrendsFabulous [是否赞过该评论 0-否，1-是]
  //  * trendsFabulousList [点赞列表]
//  * userLabel [用户标签]0-没有标签，3-视频认证，2-身份认证，1-头像认证
  int uid = 0;
  int? sex;
  String? headImgUrl;
  String? cname;
  int? height;
  String? constellation;
  int? age;
  String? region;
  int? trendsId;
  String? video;
  String? content;
  List<String?> imgArr = [];
  int? fabulousSum;
  int? commentSum;
  int? beClickedSum;
  String? time;
  int? type;
  String? area;
  List<String?>? commentList;
  int? isTrendsFabulous;
  List<String?>? trendsFabulousList;
  int? userLabel;

  VideoTrendsInfo();

  factory VideoTrendsInfo.fromJson(Map<String, dynamic> json) =>
      _$VideoTrendsInfoFromJson(json);

  Map<String?, dynamic> toJson() => _$VideoTrendsInfoToJson(this);
}
