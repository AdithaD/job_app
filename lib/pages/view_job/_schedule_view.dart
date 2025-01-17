part of 'view_job_page.dart';

class _ScheduleView extends ConsumerWidget {
  final Job job;

  const _ScheduleView({
    required this.job,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Flexible(
      child: _ViewJobContainer(
        title: "Schedule",
        onEdit: () => showDialog(
          context: context,
          builder: (context) => _ScheduleEditDialog(
            job: job,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ViewField(
                  fieldName: "Status",
                  child: JobStatusBadge(status: job.jobStatus)),
              const SizedBox(
                height: 16,
              ),
              ViewField(
                fieldName: "Scheduled Date",
                child: ViewFieldText(
                  job.scheduledDate == null
                      ? ""
                      : dateFormat.format(job.scheduledDate!),
                  defaultValue: "No scheduled date",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScheduleEditDialog extends ConsumerStatefulWidget {
  final Job job;

  const _ScheduleEditDialog({required this.job});

  @override
  ConsumerState<_ScheduleEditDialog> createState() =>
      _ScheduleEditDialogState();
}

class _ScheduleEditDialogState extends ConsumerState<_ScheduleEditDialog> {
  late JobStatus _newStatus;
  late DateTime? _newDate;

  @override
  void initState() {
    super.initState();
    _newStatus = widget.job.jobStatus;
    _newDate = widget.job.scheduledDate;
  }

  Future<void> _save() async {
    var newJob = widget.job;
    newJob.jobStatus = _newStatus;
    newJob.scheduledDate = _newDate;

    await requestErrorHandler(
      context,
      () async {
        var jobs = await ref.read(jobsPod.future);

        await jobs.update(widget.job.id!, body: newJob.toJson());

        ref.invalidate(jobByIdPod(widget.job.id!));
      },
      errorMessage: "Error saving schedule details",
      successMessage: "Schedule details saved",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 400,
        width: 400,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Schedule",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Status",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 2),
                DropdownButton(
                  value: _newStatus,
                  isExpanded: true,
                  padding: const EdgeInsets.all(2.0),
                  items: JobStatus.values
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(
                              jobStatusStringMap[status] ?? status.toString(),
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      )
                      .toList(),
                  onChanged: (status) => setState(() {
                    _newStatus = status ?? widget.job.jobStatus;
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Scheduled Date",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _newDate == null ? "None" : dateFormat.format(_newDate!),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    IconButton.filled(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: () => _selectDateTime(context),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            ElevatedButton(
              onPressed: () async {
                await _save();

                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (context.mounted) {
      if (date != null) {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        var dateTime = DateTime(date.year, date.month, date.day);

        if (time != null) {
          dateTime =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);
        }

        setState(() {
          _newDate = dateTime;
        });
      }
    }
  }
}
