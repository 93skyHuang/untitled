import 'package:json_annotation/json_annotation.dart';

part 'album_bean.g.dart';

///添加评论返回信息
///
@JsonSerializable()
class AlbumBean {
// * id [相册ID]
// * uid [发布者的UID]
// * imgArr [图片集]
// * date [时间]
  int id = -1;
  int uid = -1;
  List<String>? imgArr;
  String? date;

  AlbumBean();

  factory AlbumBean.fromJson(Map<String, dynamic> json) =>
      _$AddCommentRespFromJson(json);

  Map<String?, dynamic> toJson() => _$AddCommentRespToJson(this);
}
