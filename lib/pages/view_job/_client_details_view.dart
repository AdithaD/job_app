part of 'view_job_page.dart';

class _ClientDetailsView extends StatelessWidget {
  final Job job;
  const _ClientDetailsView({
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: _ViewJobContainer(
        title: "Client",
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ViewField(
                fieldName: "Name",
                child: Text(job.client.name),
              ),
              const SizedBox(
                height: 16,
              ),
              ViewField(
                fieldName: "Email",
                child: Text(job.client.email ?? ""),
              ),
              const SizedBox(
                height: 16,
              ),
              ViewField(
                fieldName: "Phone",
                child: Text(job.client.phone ?? ""),
              ),
            ],
          ),
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

  @override
  void initState() {
    super.initState();

    _newTagController = TextEditingController();
    _locationController = TextEditingController();
    _descriptionController = TextEditingController();

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
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Details",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            labelText: "Location",
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          minLines: 4,
                          maxLines: 8,
                          controller: _descriptionController,
                          decoration: const InputDecoration(
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
            ElevatedButton(onPressed: _saveData, child: const Text("Save"))
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
  void _saveData() async {
    Navigator.of(context).pop();

    var jobs = ref.read(jobsPod).valueOrNull;

    var newJob = widget.job;
    newJob.description = _descriptionController.text;
    newJob.location = _locationController.text;

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
        tags.add(Tag(name: tagName, id: existingTagNames[tagName], owner: uid));
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
    ref.invalidate(jobsPod);
    ref.invalidate(jobByIdPod(widget.job.id!));
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
