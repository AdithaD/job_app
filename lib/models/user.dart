import 'package:job_app/models/business_details.dart';
import 'package:job_app/models/payment_details.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String? id;
  String email;
  String name;
  String username;
  bool verified;

  BusinessDetails? business;
  PaymentDetails? payment;

  String? logo;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromRecord(RecordModel record) => User.fromJson(record.data);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
    required this.verified,
    this.logo,
    this.business,
    this.payment,
  });
}
