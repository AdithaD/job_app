import 'package:flutter/material.dart';
import 'package:job_app/models/job.dart';

class PaymentStatusBadge extends StatelessWidget {
  final PaymentStatus status;

  const PaymentStatusBadge({
    super.key,
    required this.status,
  });

  static const colorMap = {
    PaymentStatus.paid: Colors.green,
    PaymentStatus.unquoted: Colors.grey,
    PaymentStatus.quoted: Colors.blue,
    PaymentStatus.invoiced: Colors.yellow,
  };

  static const statusMap = {
    PaymentStatus.paid: "Paid",
    PaymentStatus.unquoted: "Unquoted",
    PaymentStatus.quoted: "Quoted",
    PaymentStatus.invoiced: "Invoiced",
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
