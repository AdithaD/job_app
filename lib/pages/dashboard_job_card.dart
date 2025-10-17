import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/api.dart';
import 'package:job_app/components/job_status_badge.dart';
import 'package:job_app/components/payment_status_badge.dart';
import 'package:job_app/components/tag_list.dart';
import 'package:job_app/main.dart';

class JobCard extends ConsumerWidget {
  final String jobId;

  const JobCard({
    super.key,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var job = ref.watch(jobByIdPod(jobId));

    return job.when(
      error: (object, stacktrace) => Text("Error ${object.toString()}"),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (job) => SizedBox(
        height: 250,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Text(
                    "UD-${job.jobId}",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Colors.blueGrey.shade400),
                  ),
                  if (job.referenceId != null) ...[
                    Spacer(),
                    Text(
                      "${job.referenceId}",
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Colors.blueGrey.shade400),
                    )
                  ]
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(job.title,
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(
                            height: 12,
                          ),
                          TagList(
                            tags: job.tags,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          if (job.client != null)
                            Row(
                              children: [
                                const Icon(Icons.person),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(job.client!.name),
                              ],
                            ),
                          Row(
                            children: [
                              const Icon(Icons.home),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(job.location)
                            ],
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            JobStatusBadge(status: job.jobStatus),
                            const SizedBox(height: 4),
                            if (job.scheduledDate != null)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(Icons.calendar_month),
                                  Text(dateFormat.format(job.scheduledDate!),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ],
                              ),
                            const SizedBox(height: 8),
                            PaymentStatusBadge(status: job.paymentStatus),
                            Expanded(child: Container()),
                          ],
                        ))
                  ],
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
