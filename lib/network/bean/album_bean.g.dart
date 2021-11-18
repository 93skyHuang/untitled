// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumBean _$AddCommentRespFromJson(Map<String, dynamic> json) {
  return AlbumBean()
    ..id = json['id'] as int
    ..uid = json['uid'] as int
    ..date = json['date'] as String?
    ..imgArr = (json['imgArr']  as List<String>?)
        ?.map((e) => e)
        .toList();
}

Map<String, dynamic> _$AddCommentRespToJson(AlbumBean instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
    };
