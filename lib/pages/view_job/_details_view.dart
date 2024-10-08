part of 'view_job_page.dart';

class _DetailsView extends StatelessWidget {
  const _DetailsView({
    required this.job,
  });

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: _ViewJobContainer(
        title: "Details",
        onEdit: () => showDialog(
            context: context,
            builder: (context) => _DetailsEditDialog(
                  job: job,
                )),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ViewField(
                      fieldName: "Job ID",
                      child: Text("UD-${job.jobId.toString()}"),
                    ),
                    Spacer(),
                    ViewField(
                        fieldName: "Ref. ID",
                        child: ViewFieldText(job.referenceId,
                            defaultValue: "No Ref. ID")),
                    Spacer()
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                ViewField(
                  fieldName: "Tags",
                  child: (job.tags.isEmpty)
                      ? Row(children: [
                          Text("No tags",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontStyle: FontStyle.italic))
                        ])
                      : TagList(tags: job.tags),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: ViewField(
                        fieldName: "Location",
                        child: ViewFieldText(job.location,
                            defaultValue: "No location entered."),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ViewField(
                    fieldName: "Description",
                    child: SingleChildScrollView(
                      child: ViewFieldText(job.description,
                          defaultValue: "No description entered."),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

class _DetailsEditDialog extends ConsumerStatefulWidget {
  final Job job;

  const _DetailsEditDialog({required this.job});

  @override
  ConsumerState<_DetailsEditDialog> createState() => _DetailsEditDialogState();
}

class _DetailsEditDialogState extends ConsumerState<_DetailsEditDialog> {
  List<String> tagNames = [];

  late TextEditingController _newTagController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;

  late TextEditingController _referenceIdController;

  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.job.title);

    _newTagController = TextEditingController();
    _locationController = TextEditingController();
    _descriptionController = TextEditingController();

    _referenceIdController =
        TextEditingController(text: widget.job.referenceId ?? "");

    _locationController.text = widget.job.location;
    _descriptionController.text = widget.job.description ?? "";

    tagNames = widget.job.tags.map((tag) => tag.name).toList();
  }

  @override
  void dispose() {
    super.dispose();
    _newTagController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();

    _referenceIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 600,
        width: 800,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Edit Details",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Title",
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _referenceIdController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Reference ID",
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Location",
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          minLines: 4,
                          maxLines: 8,
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Description",
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const VerticalDivider(),
                  const SizedBox(width: 16),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Tags",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: ListView.builder(
                              itemCount: tagNames.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(tagNames[index]),
                                  trailing: IconButton(
                                    onPressed: () => setState(() {
                                      tagNames.removeAt(index);
                                    }),
                                    icon: const Icon(Icons.delete),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _newTagController,
                                decoration: const InputDecoration(
                                  labelText: "New Tag",
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            IconButton.filledTonal(
                              onPressed: _addTag,
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () => _saveData(context), child: const Text("Save"))
          ],
        ),
      ),
    );
  }

  /// Save the changes to the job and pop the dialog off the navigator.
  ///
  /// The description and location fields are updated on the job and saved to the
  /// database. The tags field is also updated. If the tag does not exist, it is
  /// created. The job is then updated in the database. The job listing and job
  /// detail pages are also invalidated so that they will be reloaded with the new
  /// data when they are visited again.
  void _saveData(BuildContext context) async {
    var jobs = ref.read(jobsPod).valueOrNull;

    var newJob = widget.job;

    newJob.title = _titleController.text;
    newJob.description = _descriptionController.text;
    newJob.location = _locationController.text;
    newJob.referenceId = _referenceIdController.text;

    requestErrorHandler(context, () async {
      var tPod = ref.read(tagsPod.future);
      var tagCollection = await tPod;

      var authStore = ref.read(authStorePod).valueOrNull;

      var existingTags = await tagCollection.getFullList();

      var existingTagNames = existingTags.fold(<String, String>{}, (accum, rm) {
        accum.putIfAbsent(rm.getStringValue("name"), () => rm.id);
        return accum;
      });

      var uid = authStore?.model.id;

      var tags = <Tag>[];
      for (var tagName in tagNames) {
        if (existingTagNames.containsKey(tagName)) {
          tags.add(
              Tag(name: tagName, id: existingTagNames[tagName], owner: uid));
        } else {
          var rm = await tagCollection
              .create(body: <String, dynamic>{"name": tagName, "owner": uid});
          tags.add(Tag.fromRecord(rm));
        }
      }

      newJob.tags = tags;

      if (jobs != null) {
        var body = newJob.toJson();
        await jobs.update(widget.job.id!, body: body);
      }

      ref.invalidate(jobByIdPod(widget.job.id!));
      if (context.mounted) Navigator.of(context).pop();
    });
  }

  void _addTag() {
    if (!tagNames.contains(_newTagController.text)) {
      setState(() {
        tagNames.add(_newTagController.text);
        _newTagController.clear();
      });
    }
  }
}
