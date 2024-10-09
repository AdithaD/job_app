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
  PaymentStatus.invoiced: Colors.deepOrange,
};

const paymentStatusStringMap = {
  PaymentStatus.paid: "Paid",
  PaymentStatus.unquoted: "Unquoted",
  PaymentStatus.quoted: "Quoted",
  PaymentStatus.invoiced: "Invoiced",
};
String? validateInt(String? value, String fieldName, {int? min, int? max}) {
  if (value == null || value.isEmpty) {
    return "$fieldName is required.";
  } else {
    var num = int.tryParse(value);
    if (num == null) {
      return "$fieldName must be a number.";
    } else {
      if (min != null && num < min) {
        return "$fieldName must be greater than $min.";
      } else if (max != null && num > max) {
        return "$fieldName must be less than $max.";
      } else {
        return null;
      }
    }
  }
}

String? validateDouble(String? value, String fieldName,
    {double? min, double? max}) {
  if (value == null || value.isEmpty) {
    return "$fieldName is required.";
  } else {
    var num = double.tryParse(value);
    if (num == null) {
      return "$fieldName must be a number.";
    } else {
      if (min != null && num < min) {
        return "$fieldName must be greater than $min.";
      } else if (max != null && num > max) {
        return "$fieldName must be less than $max.";
      } else {
        return null;
      }
    }
  }
}

String getStringIfNotEmptyOrNull(String? value, String defaultValue) {
  if (value == null || value.isEmpty) {
    return defaultValue;
  } else {
    return value;
  }
}

class ViewFieldText extends StatelessWidget {
  final String? value;
  final String defaultValue;

  const ViewFieldText(this.value, {super.key, required this.defaultValue});

  @override
  Widget build(BuildContext context) {
    final val = value;
    if (val == null || val.isEmpty) {
      return Text(defaultValue,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontStyle: FontStyle.italic));
    } else {
      return Text(val, style: Theme.of(context).textTheme.bodyMedium);
    }
  }
}
