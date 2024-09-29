import 'package:json_annotation/json_annotation.dart';

part 'job_attachment.g.dart';

@JsonSerializable()
class JobAttachment {
  final String name;
  final String? file;

  JobAttachment({required this.name, this.file});

  factory JobAttachment.fromJson(Map<String, dynamic> json) =>
      _$JobAttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$JobAttachmentToJson(this);
}
