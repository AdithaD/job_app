import 'package:flutter/material.dart';
import 'package:job_app/main.dart';

class ViewJobListCard extends StatelessWidget {
  final DateTime updated;

  final Widget child;

  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ViewJobListCard({
    super.key,
    required this.child,
    required this.updated,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            child,
            const SizedBox(
              height: 24,
            ),
            const Divider(),
            Row(
              children: [
                Text("Updated: ${dateFormat.format(updated)}",
                    style: Theme.of(context).textTheme.labelMedium),
                const Spacer(),
                IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
                IconButton(onPressed: onDelete, icon: const Icon(Icons.delete))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
