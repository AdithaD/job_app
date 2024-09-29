import 'package:json_annotation/json_annotation.dart';

part 'job_material.g.dart';

@JsonSerializable()
class JobMaterial {
  final String name;
  final double price;
  final int quantity;
  final bool saved;

  factory JobMaterial.fromJson(Map<String, dynamic> json) =>
      _$JobMaterialFromJson(json);

  Map<String, dynamic> toJson() => _$JobMaterialToJson(this);

  JobMaterial(this.name, this.price, this.quantity, {this.saved = false});
}
