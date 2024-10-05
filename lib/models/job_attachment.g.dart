// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobAttachment _$JobAttachmentFromJson(Map<String, dynamic> json) =>
    JobAttachment(
      id: json['id'] as String?,
      name: json['name'] as String,
      file: json['file'] as String?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$JobAttachmentToJson(JobAttachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file': instance.file,
      'created': instance.created?.toIso8601String(),
      'updated': instance.updated?.toIso8601String(),
    };
