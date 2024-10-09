// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
      id: json['id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      owner: json['owner'] as String?,
    );

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
    };
