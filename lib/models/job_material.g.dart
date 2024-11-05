// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_material.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobMaterial _$JobMaterialFromJson(Map<String, dynamic> json) => JobMaterial(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$JobMaterialToJson(JobMaterial instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
    };
