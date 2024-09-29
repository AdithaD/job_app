import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag {
  String owner;
  String name;

  factory Tag.fromRecord(RecordModel record) => Tag.fromJson(record.toJson());

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);

  Tag({required this.owner, required this.name});
}
