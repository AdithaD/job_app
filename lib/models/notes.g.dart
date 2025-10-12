// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
  id: json['id'] as String?,
  owner: json['owner'] as String?,
  text: json['text'] as String,
  created: json['created'] == null
      ? null
      : DateTime.parse(json['created'] as String),
  updated: json['updated'] == null
      ? null
      : DateTime.parse(json['updated'] as String),
);

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
  'id': instance.id,
  'owner': instance.owner,
  'text': instance.text,
  'created': instance.created?.toIso8601String(),
  'updated': instance.updated?.toIso8601String(),
};
