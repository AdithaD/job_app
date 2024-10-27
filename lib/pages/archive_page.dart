import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/api.dart';
import 'package:job_app/components/job_status_badge.dart';
import 'package:job_app/components/payment_status_badge.dart';
import 'package:job_app/components/strings.dart';
import 'package:job_app/main.dart';
import 'package:job_app/models/job.dart';
import 'package:collection/collection.dart';
import 'package:job_app/pages/view_job/view_job_page.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Archive'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ArchivePageBody(),
      ),
    );
  }
}

class ArchivePageBody extends ConsumerWidget {
  const ArchivePageBody({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var jobs = ref.watch(allJobsPod);

    return jobs.when(
      data: (data) => SizedBox(
        width: double.infinity,
        child: ArchiveDataTable(
            jobs: data.map((rm) => Job.fromRecord(rm)).toList()),
      ),
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => Center(child: const CircularProgressIndicator()),
    );
  }
}

class ArchiveDataTable extends StatefulWidget {
  final List<Job> jobs;

  const ArchiveDataTable({
    super.key,
    required this.jobs,
  });

  @override
  State<ArchiveDataTable> createState() => _ArchiveDataTableState();
}

class _ArchiveDataTableState extends State<ArchiveDataTable> {
  final Set<int> _selected = {};

  int columnIndex = 0;
  bool isAscending = true;

  Set<PaymentStatus> _filterPaymentStatuses = {};
  Set<JobStatus> _filterJobStatuses = {};

  @override
  Widget build(BuildContext context) {
    var filteredJobs = widget.jobs
        .where(
          (job) =>
              _filterPaymentStatuses.isEmpty ||
              _filterPaymentStatuses.contains(job.paymentStatus),
        )
        .where(
          (job) =>
              _filterJobStatuses.isEmpty ||
              _filterJobStatuses.contains(job.jobStatus),
        )
        .sortedByCompare((job) => job.scheduledDate, compareDateTimeNullLast)
        .map(_createDataRow)
        .toList();

    var totalExpenses =
        widget.jobs.fold(0.0, (total, job) => total + job.totalExpenses);

    var totalReceived =
        widget.jobs.fold(0.0, (total, job) => total + job.receivedAmount);

    var netAmount = totalReceived - totalExpenses;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 80,
          child: Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Status',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Flexible(
                      child: SegmentedButton(
                        emptySelectionAllowed: true,
                        multiSelectionEnabled: true,
                        segments: [
                          ...List.generate(
                            PaymentStatus.values.length,
                            (index) => ButtonSegment<PaymentStatus>(
                              value: PaymentStatus.values[index],
                              label: Text(
                                paymentStatusStringMap[
                                        PaymentStatus.values[index]] ??
                                    PaymentStatus.values[index].toString(),
                              ),
                            ),
                          )
                        ],
                        selected: _filterPaymentStatuses,
                        onSelectionChanged: (value) {
                          setState(() {
                            _filterPaymentStatuses = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 32,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Job Status',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Flexible(
                      child: SegmentedButton(
                        emptySelectionAllowed: true,
                        multiSelectionEnabled: true,
                        segments: [
                          ...List.generate(
                            JobStatus.values.length,
                            (index) => ButtonSegment<JobStatus>(
                              value: JobStatus.values[index],
                              label: Text(
                                jobStatusStringMap[JobStatus.values[index]] ??
                                    JobStatus.values[index].toString(),
                              ),
                            ),
                          )
                        ],
                        selected: _filterJobStatuses,
                        onSelectionChanged: (value) {
                          setState(() {
                            _filterJobStatuses = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(),
        Expanded(
          child: Builder(builder: (context) {
            if (filteredJobs.isEmpty) {
              return Center(child: Text("No jobs found."));
            } else {
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Theme.of(context).colorScheme.inversePrimary,
                )),
                child: DataTable(
                  sortColumnIndex: columnIndex,
                  sortAscending: isAscending,
                  headingTextStyle: Theme.of(context).textTheme.labelLarge,
                  showCheckboxColumn: true,
                  columns: <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Scheduled Date',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          columnIndex = columnIndex;
                          isAscending = ascending;
                        });
                      },
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Job Name',
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Address',
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Payment',
                      ),
                    ),
                    DataColumn(
                      numeric: true,
                      label: Text(
                        'Paid Amount',
                      ),
                    ),
                    DataColumn(
                      numeric: true,
                      label: Text(
                        'Expenses',
                      ),
                    ),
                  ],
                  rows: filteredJobs,
                ),
              );
            }
          }),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 128,
          width: double.infinity,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                      title: "Total Jobs",
                      value: filteredJobs.length.toString()),
                ),
                Expanded(
                  child: StatCard(
                    title: "Total Received",
                    value: totalReceived.toStringAsFixed(2),
                  ),
                ),
                Expanded(
                  child: StatCard(
                    title: "Total Expenses",
                    value: totalExpenses.toStringAsFixed(2),
                  ),
                ),
                Expanded(
                  child: StatCard(
                    title: "Net amount",
                    value: netAmount.toStringAsFixed(2),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  DataRow _createDataRow(Job job) {
    return DataRow(
      selected: _selected.contains(job.jobId),
      onLongPress: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ViewJobPage(jobId: job.id!),
        ),
      ),
      onSelectChanged: (value) => setState(() {
        if (value == true) {
          _selected.add(job.jobId);
        } else {
          _selected.remove(job.jobId);
        }
      }),
      cells: [
        DataCell(
            Text(job.scheduledDate == null
                ? "No scheduled date"
                : dateFormat.format(job.scheduledDate!)),
            placeholder: job.scheduledDate == null),
        DataCell(SizedBox(width: 100, child: Text(job.title))),
        DataCell(SizedBox(width: 200, child: Text(job.location))),
        DataCell(JobStatusBadge(status: job.jobStatus)),
        DataCell(PaymentStatusBadge(status: job.paymentStatus)),
        DataCell(Text(job.receivedAmount.toString())),
        DataCell(Text(job.totalExpenses.toString())),
      ],
    );
  }

  int compareDateTimeNullLast(DateTime? a, DateTime? b) {
    if (isAscending) {
      if (a == null) {
        return 1;
      } else if (b == null) {
        return -1;
      } else {
        return a.compareTo(b);
      }
    } else {
      if (a == null) {
        return -1;
      } else if (b == null) {
        return 1;
      } else {
        return b.compareTo(a);
      }
    }
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  const StatCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
