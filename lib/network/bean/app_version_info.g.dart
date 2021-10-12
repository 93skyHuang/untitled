// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersionInfo _$AppVersionInfoFromJson(Map<String, dynamic> json) =>
    AppVersionInfo()
      ..versionIsUp = json['versionIsUp'] as int
      ..versionName = json['versionName'] as String?
      ..versionUrl = json['versionUrl'] as String?
      ..versionCode = json['versionCode'] as String?
      ..versionDescription = json['versionDescription'] as String?;

Map<String, dynamic> _$AppVersionInfoToJson(AppVersionInfo instance) =>
    <String, dynamic>{
      'versionIsUp': instance.versionIsUp,
      'versionName': instance.versionName,
      'versionUrl': instance.versionUrl,
      'versionCode': instance.versionCode,
      'versionDescription': instance.versionDescription,
    };
