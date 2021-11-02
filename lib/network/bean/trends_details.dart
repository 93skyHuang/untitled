import 'package:json_annotation/json_annotation.dart';

part 'trends_details.g.dart';

///动态详情
@JsonSerializable()
class TrendsDetails {
  //  * id [动态ID]
  //  * uid [发布人UID]
  //  * video [视频地址]
  //  * content [动态内容]
  //  * imgArr [动态图片]
  //  * type [动态类型 0-心情（只有一段文字），1-动态（有文字和图片），2-视频]
  //  * time [发布时间]
  //  * fabulousSum [被赞次数]
  //  * commentSum [被评论次数]
  //  * area [区域]
  //  * isfabulous [是否已赞 0-否，1-是]
  //  * isfollow [是否已关注发布者 0-否，1-是]
  //  * fabulousList [点赞人列表]
  int uid = 0;
  int id = 0;
  String? video;
  String? content;
  List<String?> imgArr = [];
  int? type;
  String? time;
  String? area;
  String? cname = '';
  int? isfabulous;
  int? isfollow;
  int? fabulousSum;
  List<String?>? fabulousList;
  String? headImgUrl = '';


  TrendsDetails();

  factory TrendsDetails.fromJson(Map<String, dynamic> json) =>
      _$TrendsDetailsFromJson(json);

  Map<String?, dynamic> toJson() => _$TrendsDetailsToJson(this);
}
