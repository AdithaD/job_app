// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_colors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagColor _$TagColorFromJson(Map<String, dynamic> json) => TagColor(
      json['name'] as String,
      (json['color'] as num).toInt(),
      id: json['id'] as String?,
      owner: json['owner'] as String?,
    );

Map<String, dynamic> _$TagColorToJson(TagColor instance) => <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'name': instance.name,
      'color': instance.color,
    };
