// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_preset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaterialPreset _$MaterialPresetFromJson(Map<String, dynamic> json) =>
    MaterialPreset(
      json['name'] as String,
      (json['price'] as num).toDouble(),
      id: json['id'] as String?,
      owner: json['owner'] as String?,
    );

Map<String, dynamic> _$MaterialPresetToJson(MaterialPreset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'name': instance.name,
      'price': instance.price,
    };
