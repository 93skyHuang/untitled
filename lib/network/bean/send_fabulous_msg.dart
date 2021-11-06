import 'package:json_annotation/json_annotation.dart';

import 'dynamic_content.dart';

part 'send_fabulous_msg.g.dart';

/// 发出的消息 - 评论
@JsonSerializable()
class SendFabulousMsg {
  //          * id [ID]
  //      * headImgUrl [点赞人头像]
  //      * trendsId [被点赞动态ID]
  //      * isRead [是否回看过对方 0-否，1-是]
  //      * cname [评论人昵称]
  //      * trendsContent [动态内容]
  //      * date [评论时间]
  //      * thisContent [动态内容]（imgArr-动态图片,id-动态id,type-动态类型【0-心情（只有一段文字），1-动态（有文字和图片），2-视频】）

  int id = -1;
  int uid = -1;
  int isRead = -1;
  int? trendsId;
  String? headImgUrl ;
  String? cname ;
  String? trendsContent ;
  String? date;
  int? age = 1;
  String? constellation = '';
  String? region = '';
  // DynamicContent? thisContent;


  SendFabulousMsg();

  factory SendFabulousMsg.fromJson(Map<String, dynamic> json) =>
      _$SendFabulousMsgFromJson(json);

  Map<String?, dynamic> toJson() => _$SendFabulousMsgToJson(this);
}
