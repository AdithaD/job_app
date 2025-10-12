// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentDetails _$PaymentDetailsFromJson(Map<String, dynamic> json) =>
    PaymentDetails(
        bankName: json['bankName'] as String?,
        accountName: json['accountName'] as String?,
        accountNumber: json['accountNumber'] as String?,
        bsb: json['bsb'] as String?,
        paymentTerms: json['paymentTerms'] as String?,
      )
      ..id = json['id'] as String?
      ..owner = json['owner'] as String?;

Map<String, dynamic> _$PaymentDetailsToJson(PaymentDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'bankName': instance.bankName,
      'accountName': instance.accountName,
      'accountNumber': instance.accountNumber,
      'bsb': instance.bsb,
      'paymentTerms': instance.paymentTerms,
    };
