import 'package:json_annotation/json_annotation.dart';

part 'holder_data.g.dart';

/**
 * 占位确定数据后在修改
 */
@JsonSerializable()
class HolderData {
  HolderData();

  factory HolderData.fromJson(Map<String, dynamic> json) =>
      _$HolderDataFromJson(json);
}
