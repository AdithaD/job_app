// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) => Job(
      id: json['id'] as String? ?? "",
      jobId: (json['jobId'] as num).toInt(),
      title: json['title'] as String,
      client: Client.fromJson(
          readExpandedClientJSON(json, 'client') as Map<String, dynamic>),
      location: json['location'] as String,
      description: json['description'] as String?,
      scheduledDate: json['scheduledDate'] == null
          ? null
          : DateTime.parse(json['scheduledDate'] as String),
      jobStatus: $enumDecodeNullable(_$JobStatusEnumMap, json['jobStatus']) ??
          JobStatus.unscheduled,
      paymentStatus:
          $enumDecodeNullable(_$PaymentStatusEnumMap, json['paymentStatus']) ??
              PaymentStatus.unquoted,
      quotedPrice: (json['quotedPrice'] as num?)?.toDouble(),
      tags: (readExpandedTagsJSON(json, 'tags') as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      materials:
          (readExpandedMaterialsJSON(json, 'materials') as List<dynamic>?)
              ?.map((e) => JobMaterial.fromJson(e as Map<String, dynamic>))
              .toList(),
      attachments:
          (readExpandedAttachmentsJSON(json, 'attachments') as List<dynamic>?)
              ?.map((e) => JobAttachment.fromJson(e as Map<String, dynamic>))
              .toList(),
      notes: (readExpandedNotesJSON(json, 'notes') as List<dynamic>?)
          ?.map((e) => Note.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'id': instance.id,
      'jobId': instance.jobId,
      'title': instance.title,
      'description': instance.description,
      'client': clientIdGetter(instance.client),
      'location': instance.location,
      'tags': tagIdsGetter(instance.tags),
      'scheduledDate': instance.scheduledDate?.toIso8601String(),
      'jobStatus': _$JobStatusEnumMap[instance.jobStatus]!,
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'quotedPrice': instance.quotedPrice,
      'materials': materialIdsGetter(instance.materials),
      'notes': noteIdsGetter(instance.notes),
      'attachments': attachmentIdsGetter(instance.attachments),
    };

const _$JobStatusEnumMap = {
  JobStatus.unscheduled: 'unscheduled',
  JobStatus.scheduled: 'scheduled',
  JobStatus.inProgress: 'inProgress',
  JobStatus.completed: 'completed',
  JobStatus.cancelled: 'cancelled',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.unquoted: 'unquoted',
  PaymentStatus.quoted: 'quoted',
  PaymentStatus.invoiced: 'invoiced',
  PaymentStatus.paid: 'paid',
};
