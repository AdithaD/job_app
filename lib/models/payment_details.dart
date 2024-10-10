import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'payment_details.g.dart';

@JsonSerializable()
class PaymentDetails {
  String? id;
  String? owner;

  String bankName;
  String accountName;
  String accountNumber;
  String bsb;

  factory PaymentDetails.fromJson(Map<String, dynamic> json) =>
      _$PaymentDetailsFromJson(json);

  factory PaymentDetails.fromRecord(RecordModel record) =>
      PaymentDetails.fromJson(record.toJson());

  Map<String, dynamic> toJson() => _$PaymentDetailsToJson(this);

  PaymentDetails({
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
    required this.bsb,
  });
}
