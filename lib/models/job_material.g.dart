// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_material.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobMaterial _$JobMaterialFromJson(Map<String, dynamic> json) => JobMaterial(
      id: json['id'] as String?,
      name: json['name'] as String,
      owner: json['owner'] as String?,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      saved: json['saved'] as bool? ?? false,
    );

Map<String, dynamic> _$JobMaterialToJson(JobMaterial instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'saved': instance.saved,
    };
