
import 'package:json_annotation/json_annotation.dart';
part 'find_tab_info.g.dart';

@JsonSerializable()
class FindTabInfo {
  int id;
  String title;
  FindTabInfo({required this.id,required this.title});

  factory FindTabInfo.fromJson(Map<String, dynamic> json) =>
      _$FindTabInfoFromJson(json);

  Map<String?, dynamic> toJson() => _$FindTabInfoToJson(this);
}
