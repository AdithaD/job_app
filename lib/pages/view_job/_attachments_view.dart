part of 'view_job_page.dart';

class _AttachmentsView extends ConsumerWidget {
  final Job job;
  const _AttachmentsView({
    required this.job,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Flexible(
      child: _ViewJobContainer(
        title: "Attachments",
        showEditButton: false,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var att = job.attachments[index];

                    return ViewJobListCard(
                        onDelete: () => _deleteAttachment(att),
                        updated: att.updated!,
                        child: Row(
                          children: [
                            Text(att.name),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () => _downloadFile(context, ref, att),
                              child: const Text("Download"),
                            ),
                          ],
                        ));
                  },
                  itemCount: job.attachments.length,
                ),
              ),
              const Divider(),
              LargeElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => _AddAttachmentDialog(
                    job: job,
                  ),
                ),
                label: 'Add attachments',
              )
            ],
          ),
        ),
      ),
    );
  }

  void _downloadFile(
      BuildContext context, WidgetRef ref, JobAttachment att) async {
    var pb = await ref.read(pocketBasePod.future);

    var rm = await pb.collection("attachments").getOne(att.id!);

    var url = pb.files.getUrl(rm, att.file!);

    if (context.mounted) {
      try {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  _deleteAttachment(JobAttachment att) {}
}

class _AddAttachmentDialog extends ConsumerStatefulWidget {
  final Job job;

  const _AddAttachmentDialog({super.key, required this.job});

  @override
  ConsumerState<_AddAttachmentDialog> createState() =>
      _AddAttachmentDialogState();
}

class _AddAttachmentDialogState extends ConsumerState<_AddAttachmentDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;

  File? _selectedFile = null;

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
        height: 400,
        width: 400,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Add Attachment",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                decoration: InputDecoration(
                  label: Text(
                    "Name",
                  ),
                  border: OutlineInputBorder(),
                ),
                controller: _nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "File",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedFile == null
                          ? "No file selected"
                          : _selectedFile!.uri.pathSegments.last,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _chooseFile,
                    child: const Text("Choose file"),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const Spacer(),
              const Divider(),
              LargeElevatedButton(
                onPressed: () => _saveAttachment(context),
                label: 'Add attachment',
              )
            ],
          ),
        ),
      ),
    );
  }

  void _saveAttachment(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await requestErrorHandler(context, () async {
        var attachmentsCollection = await ref.read(attachmentsPod.future);
        var owner = await ref.read(userId.future) as String;
        var attRM = await attachmentsCollection.create(body: {
          "name": _nameController.text,
          "owner": owner,
        }, files: [
          http.MultipartFile.fromBytes(
            "file",
            _selectedFile!.readAsBytesSync(),
            filename: _selectedFile!.uri.pathSegments.last,
          ),
        ]);

        var jobsCollection = await ref.read(jobsPod.future);
        await jobsCollection.update(
          widget.job.id!,
          body: {"attachments+": attRM.id},
        );

        ref.invalidate(jobByIdPod(widget.job.id!));
      });

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _chooseFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);

      setState(() {
        _selectedFile = file;
      });
    }
  }
}
