import 'package:json_annotation/json_annotation.dart';

import 'dynamic_content.dart';

part 'receive_comment_msg.g.dart';

/// 收到的消息 - 评论
@JsonSerializable()
class ReceiveCommentMsg {
  //      * id [评论ID]
  //      * headImgUrl [评论人头像]
  //      * trendsId [被评论动态ID]
  //      * isRead [是否回看过对方 0-否，1-是]
  //      * cname [评论人昵称]
  //      * trendsContent [评论内容]
  //      * content [动态内容]
  //      * date [评论时间]
  //      * thisContent [动态内容]（imgArr-动态图片,id-动态id,type-动态类型【1-动态（有文字和图片），2-视频】）

  int id = -1;
  int isRead = -1;
  int? trendsId;
  String? headImgUrl ;
  String? cname ;
  String? trendsContent ;
  String? date;
  DynamicContent? thisContent;


  ReceiveCommentMsg();

  factory ReceiveCommentMsg.fromJson(Map<String, dynamic> json) =>
      _$ReceiveCommentMsgFromJson(json);

  Map<String?, dynamic> toJson() => _$ReceiveCommentMsgToJson(this);
}
