import 'package:json_annotation/json_annotation.dart';

part 'trends_tpoic_type_info.g.dart';

///动态-话题分类
@JsonSerializable()
class TrendsTopicTypeInfo {
  // *  * id [话题ID]
  //  * title [话题标题]
  //  * image [话题背景图]
  //  * description [话题描述]
  //  * trendsSum [该话题下有多少个动态]
  int? id = 0;
  int? sex;
  String title='';
  String? image;
  String? description;
  int? trendsSum;

  TrendsTopicTypeInfo();

  factory TrendsTopicTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$TrendsTopicTypeInfoFromJson(json);

  Map<String?, dynamic> toJson() => _$TrendsTopicTypeInfoToJson(this);
}
