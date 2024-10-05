import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/api.dart';
import 'package:job_app/components/job_status_badge.dart';
import 'package:job_app/components/payment_status_badge.dart';
import 'package:job_app/components/strings.dart';
import 'package:job_app/main.dart';
import 'package:job_app/models/job.dart';
import 'package:job_app/models/job_material.dart';
import 'package:job_app/models/notes.dart';
import 'package:job_app/models/tag.dart';
import 'package:job_app/pages/view_job/view_job_list_card.dart';

part '_schedule_view.dart';
part '_payment_view.dart';
part '_client_details_view.dart';
part '_details_view.dart';
part '_notes_view.dart';
part '_materials_view.dart';
part '_attachments_view.dart';

class ViewJobPage extends ConsumerWidget {
  final String jobId;

  const ViewJobPage({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final job = ref.watch(jobByIdPod(jobId));

    return job.when(
      error: (error, stackTrace) => Text("$error, Brother!$stackTrace"),
      loading: () => const CircularProgressIndicator(),
      data: (job) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 120,
            leading: IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text(
              job.title,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete),
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Details",
                  icon: Icon(Icons.list_alt),
                ),
                Tab(
                  text: "Pricing",
                  icon: Icon(Icons.attach_money),
                ),
                Tab(
                  text: "Attachments",
                  icon: Icon(Icons.attach_file),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 32.0),
            child: TabBarView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                _DetailsView(job: job),
                                const SizedBox(
                                  width: 16,
                                ),
                                _ClientDetailsView(job: job),
                                const SizedBox(
                                  width: 16,
                                ),
                                _ScheduleView(job: job),
                              ],
                            ),
                          ),
                          // Schedule, Quote, Attachments
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _MaterialsView(job: job),
                    const SizedBox(
                      width: 16,
                    ),
                    _PaymentView(job: job),
                  ],
                ),
                Row(
                  children: [
                    _AttachmentsView(job: job),
                    const SizedBox(
                      width: 16,
                    ),
                    _NotesView(job: job),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LargeElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;

  final String label;

  const LargeElevatedButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

class ViewField extends StatelessWidget {
  const ViewField({
    super.key,
    required this.fieldName,
    required this.child,
  });

  final String fieldName;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(fieldName, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(
          height: 8,
        ),
        child
      ],
    );
  }
}

class _ViewJobContainer extends StatelessWidget {
  final String title;

  final Widget child;
  final bool showEditButton;
  final VoidCallback? onEdit;

  const _ViewJobContainer(
      {required this.title,
      required this.child,
      this.onEdit,
      this.showEditButton = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              if (showEditButton)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: child,
        ),
      ],
    );
  }
}
