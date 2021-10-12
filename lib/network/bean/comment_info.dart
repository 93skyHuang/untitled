import 'package:json_annotation/json_annotation.dart';

part 'comment_info.g.dart';

///评论
@JsonSerializable()
class CommentInfo {
  //   	     * id [评论ID]
  // 	     * uid [评论人UID]
  // 	     * content [评论内容]
  // 	     * cname [评论人昵称]
  // 	     * fabulousSum [被赞次数]
  // 	     * replySum [被回复次数]
  // 	     * isFabulous [是否以对这个评论赞过 1-是，0-否]
  int? id;
  int? uid;
  String? content;
  String? cname;
  int? fabulousSum;
  int? replySum;
  int? isFabulous;

  CommentInfo();

  factory CommentInfo.fromJson(Map<String, dynamic> json) =>
      _$CommentInfoFromJson(json);

  Map<String?, dynamic> toJson() => _$CommentInfoToJson(this);
}
