import 'package:flutter/material.dart';
import 'package:job_app/models/job.dart';

const jobStatusColorMap = {
  JobStatus.inProgress: Colors.orange,
  JobStatus.completed: Colors.green,
  JobStatus.cancelled: Colors.red,
  JobStatus.unscheduled: Colors.grey,
  JobStatus.scheduled: Colors.blue,
};

const jobStatusStringMap = {
  JobStatus.inProgress: "In Progress",
  JobStatus.completed: "Completed",
  JobStatus.cancelled: "Cancelled",
  JobStatus.unscheduled: "Unscheduled",
  JobStatus.scheduled: "Scheduled",
};

const paymentStatusColorMap = {
  PaymentStatus.paid: Colors.green,
  PaymentStatus.unquoted: Colors.grey,
  PaymentStatus.quoted: Colors.blue,
  PaymentStatus.invoiced: Colors.yellow,
};

const paymentStatusStringMap = {
  PaymentStatus.paid: "Paid",
  PaymentStatus.unquoted: "Unquoted",
  PaymentStatus.quoted: "Quoted",
  PaymentStatus.invoiced: "Invoiced",
};
