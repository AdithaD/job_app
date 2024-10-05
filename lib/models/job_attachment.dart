import 'package:json_annotation/json_annotation.dart';

part 'job_attachment.g.dart';

@JsonSerializable()
class JobAttachment {
  final String? id;
  final String name;
  final String? file;

  final DateTime? created;
  final DateTime? updated;

  JobAttachment(
      {this.id, required this.name, this.file, this.created, this.updated});

  factory JobAttachment.fromJson(Map<String, dynamic> json) =>
      _$JobAttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$JobAttachmentToJson(this);
}
