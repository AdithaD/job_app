import 'package:flutter/material.dart';
import 'package:job_app/models/job.dart';

const colorMap = {
  JobStatus.inProgress: Colors.orange,
  JobStatus.completed: Colors.green,
  JobStatus.cancelled: Colors.red,
  JobStatus.unscheduled: Colors.grey,
  JobStatus.scheduled: Colors.blue,
};

const statusMap = {
  JobStatus.inProgress: "In Progress",
  JobStatus.completed: "Completed",
  JobStatus.cancelled: "Cancelled",
  JobStatus.unscheduled: "Unscheduled",
  JobStatus.scheduled: "Scheduled",
};
