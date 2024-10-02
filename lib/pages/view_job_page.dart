import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/api.dart';
import 'package:job_app/components/job_status_badge.dart';
import 'package:job_app/components/payment_status_badge.dart';
import 'package:job_app/main.dart';
import 'package:job_app/models/job.dart';
import 'package:job_app/models/tag.dart';

class ViewJobPage extends ConsumerWidget {
  final String jobId;

  const ViewJobPage({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final job = ref.watch(jobByIdPod(jobId));

    return job.when(
      error: (error, stackTrace) =>
          Text(error.toString() + ", Brother!" + stackTrace.toString()),
      loading: () => const CircularProgressIndicator(),
      data: (job) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 120,
            leading: IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text(
              job.title,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete),
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Details",
                  icon: Icon(Icons.list_alt),
                ),
                Tab(
                  text: "Pricing",
                  icon: Icon(Icons.attach_money),
                ),
                Tab(
                  text: "Attachments",
                  icon: Icon(Icons.attach_file),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 32.0),
            child: TabBarView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                _DetailsView(job: job),
                                const SizedBox(
                                  width: 16,
                                ),
                                _ClientDetailsView(job: job),
                                const SizedBox(
                                  width: 16,
                                ),
                                _ScheduleView(job: job),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 48.0,
                          ),
                          // Schedule, Quote, Attachments
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _MaterialsView(job: job),
                    const SizedBox(
                      width: 16,
                    ),
                    _PaymentView(job: job),
                  ],
                ),
                Row(
                  children: [
                    _AttachmentsView(job: job),
                    const SizedBox(
                      width: 16,
                    ),
                    _NotesView(job: job),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ClientDetailsView extends StatelessWidget {
  final Job job;
  const _ClientDetailsView({
    super.key,
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

class _NotesView extends StatelessWidget {
  final Job job;
  const _NotesView({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: _ViewJobContainer(
        title: "Notes",
        showEditButton: false,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(""),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachmentsView extends StatelessWidget {
  final Job job;
  const _AttachmentsView({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: _ViewJobContainer(
        title: "Attachments",
        showEditButton: false,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var att = job.attachments[index];

                    return ListTile(
                      title: Text(att.name),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 4.0),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete),
                      ),
                    );
                  },
                  itemCount: job.attachments.length,
                ),
              ),
              const Divider(),
              ElevatedButton(
                  onPressed: () {}, child: const Text("Add Attachment"))
            ],
          ),
        ),
      ),
    );
  }
}

class _MaterialsView extends StatelessWidget {
  final Job job;
  const _MaterialsView({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: _ViewJobContainer(
        showEditButton: false,
        title: "Materials",
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var mat = job.materials[index];

                    var subTotal = mat.quantity * mat.price;

                    return Column(
                      children: [
                        ListTile(
                          leading: Text(
                            "${mat.quantity}x",
                          ),
                          title: Text(mat.name),
                          subtitle: Text(
                              "\$${subTotal.toStringAsFixed(2)} (${mat.price})"),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.remove_circle_sharp),
                          ),
                        ),
                        if (index < job.materials.length - 1)
                          const Divider(
                            thickness: 0.0,
                          ),
                      ],
                    );
                  },
                  itemCount: job.attachments.length,
                ),
              ),
              const Divider(),
              ElevatedButton(
                  onPressed: () {}, child: const Text("Add Material"))
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentView extends StatelessWidget {
  final Job job;

  const _PaymentView({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: _ViewJobContainer(
        title: "Payment",
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ViewField(
                fieldName: "Status",
                child: PaymentStatusBadge(status: job.paymentStatus),
              ),
              const SizedBox(
                height: 16,
              ),
              if (job.quotedPrice != null)
                ViewField(
                    fieldName: "Amount",
                    child: Text("\$${job.quotedPrice!.toStringAsFixed(2)}")),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {}, child: const Text("Generate Quote")),
                  ElevatedButton(
                      onPressed: () {}, child: const Text("Generate Invoice"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ScheduleView extends StatelessWidget {
  final Job job;

  const _ScheduleView({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: _ViewJobContainer(
        title: "Schedule",
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
              if (job.scheduledDate != null)
                ViewField(
                  fieldName: "Scheduled Date",
                  child: Text(
                    dateFormat.format(job.scheduledDate!),
                  ),
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

  const _DetailsEditDialog({super.key, required this.job});

  @override
  ConsumerState<_DetailsEditDialog> createState() => __DetailsEditDialogState();
}

class __DetailsEditDialogState extends ConsumerState<_DetailsEditDialog> {
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
        child: Form(
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

class _DetailsView extends StatelessWidget {
  const _DetailsView({
    super.key,
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
              ViewField(
                fieldName: "Tags",
                child: Row(
                  children: job.tags
                      .map(
                        (tag) => Badge(
                          backgroundColor: Colors.blue,
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              tag.name,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                      )
                      .expand((b) => [b, const SizedBox(width: 8)])
                      .toList(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ViewField(
                        fieldName: "Location", child: Text(job.location)),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                  child: ViewField(
                      fieldName: "Description",
                      child: Text(job.description ?? ""))),
            ],
          ),
        ),
      ),
    );
  }
}

class ViewField extends StatelessWidget {
  const ViewField({
    super.key,
    required this.fieldName,
    required this.child,
  });

  final String fieldName;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(fieldName, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(
          height: 8,
        ),
        child
      ],
    );
  }
}

class _ViewJobContainer extends StatelessWidget {
  final String title;

  final Widget child;
  final bool showEditButton;
  final VoidCallback? onEdit;

  const _ViewJobContainer(
      {required this.title,
      required this.child,
      this.onEdit,
      this.showEditButton = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              if (showEditButton)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: child,
        ),
      ],
    );
  }
}
