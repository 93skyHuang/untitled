import 'package:json_annotation/json_annotation.dart';

part 'nearby_info.g.dart';

///发现页信息
@JsonSerializable()
class NearbyInfo {
  // * height [身高]
  // * region [市区]
  // * cname [发布者昵称]
  // * autograph [签名]
  // * age [年龄]
  // * constellation [星座]
  // * userLabel [用户标签]0-没有标签，3-视频认证，2-身份认证，1-头像认证
  // * loginTime [最近一次登录时间]
  // * trendsImg [动态内容集合]video-视频地址，type-类型（0-心情（只有一段文字），1-动态（有文字和图片），2-视频），id-动态ID，imgArr动态图片
  // * loginTime [最近登录时间]


  String? cname;
  int? height ;
  String? region;
  String? autograph;
  String? constellation;
  String? loginTime;
  int? userLabel;
  int? age = 0;
  TrendsImg? trendsImg;


  NearbyInfo();
  factory NearbyInfo.fromJson(Map<String, dynamic> json) => _$NearbyInfoFromJson(json);

  Map<String?, dynamic> toJson() => _$NearbyInfoToJson(this);
}

@JsonSerializable()
class TrendsImg{
  //[动态内容集合]video-视频地址，type-类型（0-心情（只有一段文字），
  // 1-动态（有文字和图片），2-视频），id-动态ID，imgArr动态图片
  String? video;
  int? type;
  int? id;
  List<String?>? imgArr;

  TrendsImg();
  factory TrendsImg.fromJson(Map<String, dynamic> json) => _$TrendsImgFromJson(json);

  Map<String?, dynamic> toJson() => _$TrendsImgToJson(this);
}
