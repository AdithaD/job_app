// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_material.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobMaterial _$JobMaterialFromJson(Map<String, dynamic> json) => JobMaterial(
      json['name'] as String,
      (json['price'] as num).toDouble(),
      (json['quantity'] as num).toInt(),
      saved: json['saved'] as bool? ?? false,
    );

Map<String, dynamic> _$JobMaterialToJson(JobMaterial instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'saved': instance.saved,
    };
