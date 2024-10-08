import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/api.dart';
import 'package:job_app/components/job_status_badge.dart';
import 'package:job_app/components/payment_status_badge.dart';
import 'package:job_app/components/tag_list.dart';
import 'package:job_app/main.dart';
import 'package:job_app/models/job.dart';
import 'package:job_app/models/tag.dart';
import 'package:job_app/models/tag_colors.dart';
import 'package:job_app/pages/job_calendar.dart';
import 'package:job_app/pages/settings_page.dart';
import 'package:job_app/pages/view_job/view_job_page.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    var result = ref.watch(allJobsPod);

    return Scaffold(
      body: Row(
        children: [
          Column(
            children: [
              Expanded(
                child: NavigationRail(
                  onDestinationSelected: (value) async {
                    if (value == 3) {
                      var pb = await ref.watch(authStorePod.future);
                      pb.clear();
                      ref.invalidate(authStorePod);
                    }
                  },
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard),
                      label: Text('Dashboard'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person),
                      label: Text('Clients'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.archive),
                      label: Text('Archive'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.logout),
                      label: Text('Logout'),
                    ),
                  ],
                  selectedIndex: 0,
                  labelType: NavigationRailLabelType.all,
                ),
              ),
              Spacer(),
              Divider(),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                ),
                icon: Icon(Icons.settings),
                tooltip: "Settings",
                padding: EdgeInsets.all(8.0),
              ),
              SizedBox(
                height: 16,
              )
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Builder(
                builder: (context) {
                  return result.when(
                    error: (object, stacktrace) =>
                        Text("Error ${object.toString()}"),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    data: (jobRecordModels) {
                      var jobs = jobRecordModels
                          .map(
                            (rm) => Job.fromRecord(rm),
                          )
                          .toList();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 100,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Job Dashboard",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                // Upcoming Jobs
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Upcoming jobs"),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                      Icons.filter_alt),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(Icons.sort),
                                                )
                                              ],
                                            ),
                                          ]),
                                      Expanded(
                                          child: Container(
                                        decoration:
                                            BoxDecoration(border: Border.all()),
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView.builder(
                                              itemCount: jobs.length,
                                              itemBuilder: (context, index) {
                                                var job = jobs[index];
                                                return InkWell(
                                                  child:
                                                      JobCard(jobId: job.id!),
                                                  onTap: () {
                                                    ref.invalidate(
                                                        jobByIdPod(job.id!));
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ViewJobPage(
                                                                jobId: job.id!),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            )),
                                      )),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Maps
                                Flexible(
                                  child: JobCalendar(
                                    jobs: jobs,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            showDialog(context: context, builder: (context) => _AddJobDialog()),
        tooltip: 'Add job',
        label: const Text('Add job'),
        icon: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

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
        height: 200,
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
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(
                            height: 4,
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
                                  Text(dateFormat.format(job.scheduledDate!)),
                                ],
                              ),
                            const SizedBox(height: 8),
                            PaymentStatusBadge(status: job.paymentStatus),
                            Expanded(child: Container()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.edit))
                              ],
                            ),
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

class _AddJobDialog extends ConsumerStatefulWidget {
  const _AddJobDialog();

  @override
  ConsumerState<_AddJobDialog> createState() => _AddJobDialogState();
}

class _AddJobDialogState extends ConsumerState<_AddJobDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        height: 250,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add job",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(
                height: 32,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Job Title'),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Job title is required" : null,
                controller: _nameController,
              ),
              Spacer(),
              Divider(),
              LargeElevatedButton(
                onPressed: () => _createJob(context),
                label: "Add",
              )
            ],
          ),
        ),
      ),
    );
  }

  void _createJob(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await requestErrorHandler(context, () async {
        var jobsCollection = await ref.read(jobsPod.future);

        var jobRm = await jobsCollection.create(
          body: {
            "title": _nameController.text,
            "owner": await ref.read(userId.future) as String,
            "jobStatus": "unscheduled",
            "paymentStatus": "unquoted",
          },
        );

        if (context.mounted) {
          ref.invalidate(allJobsPod);
          Navigator.pop(context);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ViewJobPage(jobId: jobRm.id),
            ),
          );
        }
      });
    }
  }
}
