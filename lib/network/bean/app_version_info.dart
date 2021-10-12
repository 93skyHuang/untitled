import 'package:json_annotation/json_annotation.dart';

part 'app_version_info.g.dart';

@JsonSerializable()
class AppVersionInfo {
/// [是否需要更新 0-否，1-是]
  int versionIsUp = 0;
  String? versionName;
  ///[新版本下载地址]
  String? versionUrl;
  ///[服务器版本号]
  String? versionCode ;
  String? versionDescription ;

  AppVersionInfo();
  factory AppVersionInfo.fromJson(Map<String, dynamic> json) => _$AppVersionInfoFromJson(json);

  Map<String?, dynamic> toJson() => _$AppVersionInfoToJson(this);
}
