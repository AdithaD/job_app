// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessDetails _$BusinessDetailsFromJson(Map<String, dynamic> json) =>
    BusinessDetails(
      name: json['name'] as String,
      addressLine1: json['addressLine1'] as String,
      addressLine2: json['addressLine2'] as String,
      addressLine3: json['addressLine3'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      abn: json['abn'] as String,
    )
      ..id = json['id'] as String?
      ..owner = json['owner'] as String?;

Map<String, dynamic> _$BusinessDetailsToJson(BusinessDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'name': instance.name,
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'addressLine3': instance.addressLine3,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'abn': instance.abn,
    };
