import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'tag_colors.g.dart';

@JsonSerializable()
class TagColor {
  final String? id;

  final String? owner;
  final String name;
  final int color;

  TagColor(this.name, this.color, {this.id, this.owner});

  factory TagColor.fromJson(Map<String, dynamic> json) =>
      _$TagColorFromJson(json);

  factory TagColor.fromRecord(RecordModel rm) => TagColor.fromJson(rm.toJson());

  Map<String, dynamic> toJson() => _$TagColorToJson(this);
}
