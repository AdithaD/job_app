import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'business_details.g.dart';

@JsonSerializable()
class BusinessDetails {
  String? id;
  String? owner;

  String name;
  String addressLine1;
  String addressLine2;
  String addressLine3;
  String phoneNumber;
  String email;
  String abn;

  factory BusinessDetails.fromJson(Map<String, dynamic> json) =>
      _$BusinessDetailsFromJson(json);

  factory BusinessDetails.fromRecord(RecordModel rm) =>
      BusinessDetails.fromJson(rm.toJson());

  Map<String, dynamic> toJson() => _$BusinessDetailsToJson(this);

  BusinessDetails({
    required this.name,
    required this.addressLine1,
    required this.addressLine2,
    required this.addressLine3,
    required this.phoneNumber,
    required this.email,
    required this.abn,
  });
}
