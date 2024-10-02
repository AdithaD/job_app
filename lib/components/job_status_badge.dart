import 'package:flutter/material.dart';
import 'package:job_app/components/strings.dart';
import 'package:job_app/models/job.dart';

class JobStatusBadge extends StatelessWidget {
  final JobStatus status;

  const JobStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      decoration: BoxDecoration(
        color: colorMap[status] ?? Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        statusMap[status] ?? "",
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
