import 'package:job_app/models/client.dart';
import 'package:job_app/models/job_attachment.dart';
import 'package:job_app/models/job_material.dart';
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
  int jobId;
  String title;
  String? description;

  @JsonKey(readValue: readExpandedClientJSON)
  Client client;
  String location;

  @JsonKey(readValue: readExpandedTagsJSON)
  List<Tag> tags;

  DateTime? scheduledDate;
  JobStatus jobStatus;

  PaymentStatus paymentStatus;
  double? quotedPrice;

  @JsonKey(readValue: readExpandedMaterialsJSON)
  List<JobMaterial> materials;

  @JsonKey(readValue: readExpandedAttachmentsJSON)
  List<JobAttachment> attachments;

  factory Job.fromRecord(RecordModel record) => Job.fromJson(record.toJson());

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);

  Map<String, dynamic> toJson() => _$JobToJson(this);

  Job(
      {required this.jobId,
      required this.title,
      required this.client,
      required this.location,
      this.description,
      this.scheduledDate,
      this.jobStatus = JobStatus.unscheduled,
      this.paymentStatus = PaymentStatus.unquoted,
      this.quotedPrice,
      this.tags = const [],
      List<JobMaterial>? materials,
      List<JobAttachment>? attachments})
      : materials = materials ?? [],
        attachments = attachments ?? [];
}

Object? readExpandedClientJSON(Map<dynamic, dynamic> json, key) {
  return json["expand"]["client"];
}

Object? readExpandedMaterialsJSON(Map<dynamic, dynamic> json, key) {
  return json["expand"]["materials"];
}

Object? readExpandedAttachmentsJSON(Map<dynamic, dynamic> json, key) {
  return json["expand"]["attachments"];
}

Object? readExpandedTagsJSON(Map<dynamic, dynamic> json, key) {
  return json["expand"]["tags"];
}
