import 'package:json_annotation/json_annotation.dart';

part 'add_comment_resp.g.dart';

///添加评论返回信息
///
@JsonSerializable()
class AddCommentResp {
  //      * id [评论ID]
  //      * uid [评论人UID]
  //      * trendsId [动态ID]
  //      * content [动态内容]
  //      * cname [昵称]
  //      * headImgUrl [头像]
  //      * fabulousSum [被赞次数]
  //      * replySum [被回复次数]
  //      * time [时间]
  //      * isFabulous [是否已赞 0-否，1-是]
  int id = -1;
  int uid = -1;
  int? trendsId;
  String? content;
  String? cname;
  String? headImgUrl;
  int? fabulousSum;
  int? replySum;
  String? time;
  int? isFabulous;

  AddCommentResp();

  factory AddCommentResp.fromJson(Map<String, dynamic> json) =>
      _$AddCommentRespFromJson(json);

  Map<String?, dynamic> toJson() => _$AddCommentRespToJson(this);
}
