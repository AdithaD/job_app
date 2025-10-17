import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:job_app/components/job_status_badge.dart';
import 'package:job_app/models/job.dart';
import 'package:job_app/pages/view_job/view_job_page.dart';
import 'package:table_calendar/table_calendar.dart';

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
  // ignore: unused_field
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
    // Rebuild the calendar when the jobs change.

    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
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
            //return JobCard(jobId: job.id!);
            return Card(
              elevation: 1,
              child: ListTile(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewJobPage(jobId: job.id!),
                      )),
                  title: Text(job.title),
                  subtitle: job.location.isEmpty
                      ? Text("Location not specified")
                      : Text(job.location),
                  trailing: JobStatusBadge(status: job.jobStatus)),
            );
          },
        ),
      ),
    );
  }
}
