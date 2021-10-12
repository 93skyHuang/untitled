// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DynamicContent _$DynamicContentFromJson(Map<String, dynamic> json) =>
    DynamicContent()
      ..id = json['id'] as int
      ..type = json['type'] as int
      ..imgArr =
          (json['imgArr'] as List<dynamic>).map((e) => e as String?).toList();

Map<String, dynamic> _$DynamicContentToJson(DynamicContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'imgArr': instance.imgArr,
    };
