import 'package:json_annotation/json_annotation.dart';

part 'notes.g.dart';

@JsonSerializable()
class Note {
  String? id;

  String? owner;
  String text;

  DateTime? created;
  DateTime? updated;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);

  Note({
    this.id,
    this.owner,
    required this.text,
    this.created,
    this.updated,
  });
}
