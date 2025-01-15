import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'material_preset.g.dart';

@JsonSerializable()
class MaterialPreset {
  @JsonKey(name: 'id')
  String? id;
  String? owner;

  String name;
  double price;

  MaterialPreset(this.name, this.price, {this.id, this.owner});

  factory MaterialPreset.fromJson(Map<String, dynamic> json) =>
      _$MaterialPresetFromJson(json);

  factory MaterialPreset.fromRecord(RecordModel rm) =>
      MaterialPreset.fromJson(rm.toJson());

  Map<String, dynamic> toJson() => _$MaterialPresetToJson(this);
}
