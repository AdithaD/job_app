import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/api.dart';
import 'package:job_app/components/large_elevated_button.dart';
import 'package:job_app/models/job.dart';
import 'package:job_app/pages/archive_page.dart';
import 'package:job_app/pages/dashboard_job_card.dart';
import 'package:job_app/pages/job_calendar.dart';
import 'package:job_app/pages/settings/settings_page.dart';
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
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          DashboardNavigationRail(),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Builder(
                builder: (context) => result.when(
                  error: (object, stacktrace) =>
                      Text("Error ${object.toString()}"),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  data: (jobs) => _DashboardContent(jobs: jobs),
                ),
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
      ),
    );
  }
}

class _DashboardContent extends ConsumerWidget {
  final List<Job> jobs;
  const _DashboardContent({required this.jobs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var filteredJobs = jobs
        .where((job) => job.scheduledDate != null
            ? job.scheduledDate!.isAfter(DateTime.now())
            : true)
        .where((job) =>
            job.jobStatus != JobStatus.completed ||
            job.jobStatus != JobStatus.cancelled)
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
                  style: Theme.of(context).textTheme.displayLarge),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Upcoming jobs",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: filteredJobs.length,
                            itemBuilder: (context, index) {
                              var job = filteredJobs[index];
                              return InkWell(
                                child: JobCard(jobId: job.id!),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewJobPage(jobId: job.id!),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
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
  }
}

class DashboardNavigationRail extends ConsumerWidget {
  const DashboardNavigationRail({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          child: NavigationRail(
            onDestinationSelected: (value) async {
              switch (value) {
                case 0:
                  break;
                case 1:
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ArchivePage(),
                    ),
                  );
                  break;
                case 2:
                  var pb = await ref.watch(authStorePod.future);
                  pb.clear();
                  ref.invalidate(authStorePod);
                  break;
                default:
                  break;
              }
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
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
            "owner": await ref.read(userId.future),
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
      }, errorMessage: "Error creating job", successMessage: "Job created.");
    }
  }
}
