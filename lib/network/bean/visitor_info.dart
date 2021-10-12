import 'package:json_annotation/json_annotation.dart';

part 'visitor_info.g.dart';

@JsonSerializable()
class VisitorInfo {
//* uid [用户UID]
//      * headImgUrl [头像]
//      * cname [昵称]
//      * height [身高]
//     time [访问时间]

  int id = 0;
  int? uid;
  String? headImgUrl;
  String? cname;
  int? height ;
  String? time ;

  VisitorInfo();
  factory VisitorInfo.fromJson(Map<String, dynamic> json) => _$VisitorInfoFromJson(json);

  Map<String?, dynamic> toJson() => _$VisitorInfoToJson(this);
}
