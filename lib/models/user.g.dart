// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String?,
      email: json['email'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      verified: json['verified'] as bool,
      logo: json['logo'] as String?,
      business: json['business'] == null
          ? null
          : BusinessDetails.fromJson(json['business'] as Map<String, dynamic>),
      payment: json['payment'] == null
          ? null
          : PaymentDetails.fromJson(json['payment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'username': instance.username,
      'verified': instance.verified,
      'business': instance.business,
      'payment': instance.payment,
      'logo': instance.logo,
    };
