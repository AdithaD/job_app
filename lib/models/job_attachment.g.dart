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
    );

Map<String, dynamic> _$JobAttachmentToJson(JobAttachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file': instance.file,
    };
