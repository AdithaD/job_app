import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/api.dart';
import 'package:job_app/components/job_status_badge.dart';
import 'package:job_app/components/payment_status_badge.dart';
import 'package:job_app/main.dart';
import 'package:job_app/models/job.dart';
import 'package:job_app/pages/view_job/view_job_page.dart';
import 'package:table_calendar/table_calendar.dart';

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
          NavigationRail(
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
            ],
            selectedIndex: 0,
            labelType: NavigationRailLabelType.all,
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
        onPressed: () {},
        tooltip: 'Add job',
        label: const Text('Add job'),
        icon: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class JobCalendar extends StatefulWidget {
  final List<Job> jobs;

  const JobCalendar({
    super.key,
    required this.jobs,
  });

  @override
  State<JobCalendar> createState() => _JobCalendarState();
}

class _JobCalendarState extends State<JobCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late LinkedHashMap<DateTime, List<Job>> jobsByDate;

  @override
  void initState() {
    super.initState();
    jobsByDate = _groupJobsByDate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: (day) => jobsByDate[day] ?? [],
          ),
          const Divider(),
          if (_selectedDay != null)
            _JobEventList(jobsByDate: jobsByDate, selectedDay: _selectedDay)
        ],
      ),
    );
  }

  LinkedHashMap<DateTime, List<Job>> _groupJobsByDate() {
    LinkedHashMap<DateTime, List<Job>> groupedJobs = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    for (var job in widget.jobs) {
      if (job.scheduledDate != null) {
        groupedJobs.putIfAbsent(job.scheduledDate!, () => []).add(job);
      }
    }
    return groupedJobs;
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }
}

class _JobEventList extends StatelessWidget {
  const _JobEventList({
    super.key,
    required this.jobsByDate,
    required DateTime? selectedDay,
  }) : _selectedDay = selectedDay;

  final LinkedHashMap<DateTime, List<Job>> jobsByDate;
  final DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    var itemCount = jobsByDate.containsKey(_selectedDay)
        ? jobsByDate[_selectedDay]!.length
        : 0;

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            var job = jobsByDate[_selectedDay]![index];
            return JobCard(jobId: job.id!);
          },
        ),
      ),
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
              Text("#${job.jobId}"),
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
                          Row(
                            children: job.tags
                                .map((tag) => Badge(
                                      backgroundColor: Colors.blue,
                                      textColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      label: Text(tag.name),
                                    ))
                                .expand((b) => [b, const SizedBox(width: 8)])
                                .toList(),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.person),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(job.client.name),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
