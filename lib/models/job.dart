import 'package:job_app/models/client.dart';
import 'package:job_app/models/job_attachment.dart';
import 'package:job_app/models/job_material.dart';
import 'package:job_app/models/notes.dart';
import 'package:job_app/models/tag.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'job.g.dart';

enum JobStatus {
  unscheduled,
  scheduled,
  inProgress,
  completed,
  cancelled,
}

enum PaymentStatus { unquoted, quoted, invoiced, paid }

@JsonSerializable()
class Job {
  String? id;
  int jobId;
  String? referenceId;
  String title;
  String? description;

  @JsonKey(readValue: readExpandedClientJSON, toJson: clientIdGetter)
  Client? client;
  String location;

  @JsonKey(readValue: readExpandedTagsJSON, toJson: tagIdsGetter)
  List<Tag> tags;

  @JsonKey(readValue: readDateTimeJSON)
  DateTime? scheduledDate;
  JobStatus jobStatus;

  PaymentStatus paymentStatus;
  double? quotedPrice;
  double receivedAmount;

  List<JobMaterial> materials;

  @JsonKey(readValue: readExpandedNotesJSON, toJson: noteIdsGetter)
  List<Note> notes;

  @JsonKey(readValue: readExpandedAttachmentsJSON, toJson: attachmentIdsGetter)
  List<JobAttachment> attachments;

  factory Job.fromRecord(RecordModel record) => Job.fromJson(record.toJson());

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);

  Map<String, dynamic> toJson() => _$JobToJson(this);

  double get totalExpenses => materials.isEmpty
      ? 0.0
      : materials
          .map((material) => material.price * material.quantity)
          .reduce((value, element) => value + element);

  Job(
      {this.id = "",
      required this.jobId,
      required this.title,
      required this.client,
      required this.location,
      this.referenceId,
      this.description,
      this.scheduledDate,
      this.jobStatus = JobStatus.unscheduled,
      this.paymentStatus = PaymentStatus.unquoted,
      this.receivedAmount = 0.0,
      this.quotedPrice,
      this.tags = const [],
      List<JobMaterial>? materials,
      List<JobAttachment>? attachments,
      List<Note>? notes})
      : materials = materials ?? [],
        attachments = attachments ?? [],
        notes = notes ?? [];
}

String? clientIdGetter(Client? client) => client?.id;

List<String> tagIdsGetter(List<Tag> tags) {
  return tags.map((tag) => tag.id ?? "").toList();
}

List<String> attachmentIdsGetter(List<JobAttachment> attachments) {
  return attachments.map((attachment) => attachment.id ?? "").toList();
}

List<String> noteIdsGetter(List<Note> notes) {
  return notes.map((note) => note.id ?? "").toList();
}

Object? readExpandedClientJSON(Map<dynamic, dynamic> json, key) {
  return json["expand"]["client"];
}

Object? readExpandedAttachmentsJSON(Map<dynamic, dynamic> json, key) {
  return json["expand"]["attachments"];
}

Object? readExpandedTagsJSON(Map<dynamic, dynamic> json, key) {
  return json["expand"]["tags"];
}

Object? readExpandedNotesJSON(Map<dynamic, dynamic> json, key) {
  return json["expand"]["notes"];
}

Object? readDateTimeJSON(Map<dynamic, dynamic> json, key) {
  if (json[key] != null) {
    if (json[key] is String) {
      var value = json[key] as String;

      if (value.isNotEmpty) {
        return json[key];
      }
    }
  }

  return null;
}
