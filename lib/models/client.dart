import 'package:json_annotation/json_annotation.dart';

part 'client.g.dart';

@JsonSerializable()
class Client {
  final String? id;
  String? owner;
  String name;
  String? email;
  String? phone;

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  Map<String, dynamic> toJson() => _$ClientToJson(this);

  Client({this.id, required this.name, this.email, this.phone, this.owner});
}
