import 'package:json_annotation/json_annotation.dart';

part 'black_info.g.dart';

///黑名单列表
@JsonSerializable()
class BlackInfo {
  //      * id [黑名单id]
  //      * uid [对方UID]
  //      * cname [对方昵称]
  //      * autograph [对方签名]
  //      * headImgUrl [对方头像]
  //      * date [拉黑时间]
  int id = -1;

  int? uid;
  String? headImgUrl;
  String? cname ;
  String? autograph ;
  String? date ;

  BlackInfo();

  factory BlackInfo.fromJson(Map<String, dynamic> json) =>
      _$BlackInfoFromJson(json);

  Map<String?, dynamic> toJson() => _$BlackInfoToJson(this);
}
