import 'package:json_annotation/json_annotation.dart';

part 'job_material.g.dart';

@JsonSerializable()
class JobMaterial {
  String name;
  double price;
  int quantity;

  factory JobMaterial.fromJson(Map<String, dynamic> json) =>
      _$JobMaterialFromJson(json);

  Map<String, dynamic> toJson() => _$JobMaterialToJson(this);

  JobMaterial({
    required this.name,
    required this.price,
    required this.quantity,
  });
}
