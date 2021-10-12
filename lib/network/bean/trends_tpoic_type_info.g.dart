// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trends_tpoic_type_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrendsTopicTypeInfo _$TrendsTopicTypeInfoFromJson(Map<String, dynamic> json) =>
    TrendsTopicTypeInfo()
      ..id = json['id'] as int?
      ..sex = json['sex'] as int?
      ..title = json['title'] as String?
      ..image = json['image'] as String?
      ..description = json['description'] as String?
      ..trendsSum = json['trendsSum'] as int?;

Map<String, dynamic> _$TrendsTopicTypeInfoToJson(
        TrendsTopicTypeInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sex': instance.sex,
      'title': instance.title,
      'image': instance.image,
      'description': instance.description,
      'trendsSum': instance.trendsSum,
    };
