import 'package:json_annotation/json_annotation.dart';

part 'my_foot_info.g.dart';

@JsonSerializable()
class MyFootInfo {

  //* 我的足迹
  //      * index/share/myFootprint
  //      * 请求参数
  //      * uid [用户UID]
  //      * page [分页页数]
  //      * 返回信息
  //      * id [访客记录ID](没有用可以忽略)
  //      * uid [对方用户UID]
  //      * cname [对方用户昵称]
  //      * headImgUrl [对方用户头像]
  //      * height [身高]
  //      * time [访问时间]
  MyFootInfo();
  int? uid ;
  int? height;
  String? headImgUrl = '';
  String? cname = '';
  String? time = '';

  factory MyFootInfo.fromJson(Map<String, dynamic> json) =>
      _$MyFootInfoFromJson(json);

}
