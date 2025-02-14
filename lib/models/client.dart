import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'client.g.dart';

@JsonSerializable()
class Client {
  final String? id;
  String? owner;
  String name;
  String? email;
  String? phone;

  String? addressLine1;
  String? addressLine2;
  String? addressLine3;

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  factory Client.fromRecord(RecordModel rm) => Client.fromJson(rm.toJson());

  Map<String, dynamic> toJson() => _$ClientToJson(this);

  Client({this.id, required this.name, this.email, this.phone, this.owner});
}
