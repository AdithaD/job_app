import 'package:json_annotation/json_annotation.dart';

part 'job_material.g.dart';

@JsonSerializable()
class JobMaterial {
  String? id;
  String? owner;
  String name;
  double price;
  int quantity;
  bool saved;

  factory JobMaterial.fromJson(Map<String, dynamic> json) =>
      _$JobMaterialFromJson(json);

  Map<String, dynamic> toJson() => _$JobMaterialToJson(this);

  JobMaterial(
      {this.id,
      this.owner,
      required this.name,
      required this.price,
      required this.quantity,
      this.saved = false});
}
