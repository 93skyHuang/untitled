import 'package:json_annotation/json_annotation.dart';

part 'dynamic_content.g.dart';

///动态内容
@JsonSerializable()
class DynamicContent {
  ///imgArr-动态图片,id-动态id,type-动态类型【1-动态（有文字和图片），2-视频】）
  int id = -1;
  int type = -1;
  List<String?> imgArr = [];

  DynamicContent();

  factory DynamicContent.fromJson(Map<String, dynamic> json) =>
      _$DynamicContentFromJson(json);

  Map<String?, dynamic> toJson() => _$DynamicContentToJson(this);
}
