import 'package:flutter/material.dart';
import 'package:job_app/models/job.dart';

class JobStatusBadge extends StatelessWidget {
  final JobStatus status;

  const JobStatusBadge({
    super.key,
    required this.status,
  });

  static const colorMap = {
    JobStatus.inProgress: Colors.orange,
    JobStatus.completed: Colors.green,
    JobStatus.cancelled: Colors.red,
    JobStatus.unscheduled: Colors.grey,
    JobStatus.scheduled: Colors.blue,
  };

  static const statusMap = {
    JobStatus.inProgress: "In Progress",
    JobStatus.completed: "Completed",
    JobStatus.cancelled: "Cancelled",
    JobStatus.unscheduled: "Unscheduled",
    JobStatus.scheduled: "Scheduled",
  };

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
