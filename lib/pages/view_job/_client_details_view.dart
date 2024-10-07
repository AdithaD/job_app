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
        onEdit: () => showDialog(
            context: context,
            builder: (context) => _ClientDetailsEditDialog(
                  job: job,
                )),
        title: "Client",
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Builder(builder: (context) {
            if (job.client == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("No client details"),
                ],
              );
            } else {
              var client = job.client!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ViewField(
                    fieldName: "Name",
                    child: Text(client.name),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ViewField(
                    fieldName: "Email",
                    child: Text(client.email ?? ""),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ViewField(
                    fieldName: "Phone",
                    child: Text(client.phone ?? ""),
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}

class _ClientDetailsEditDialog extends ConsumerStatefulWidget {
  final Job job;

  const _ClientDetailsEditDialog({super.key, required this.job});

  @override
  ConsumerState<_ClientDetailsEditDialog> createState() =>
      _ClientDetailsEditDialogState();
}

class _ClientDetailsEditDialogState
    extends ConsumerState<_ClientDetailsEditDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.job.client?.name ?? "",
    );
    _emailController = TextEditingController(
      text: widget.job.client?.email ?? "",
    );
    _phoneController = TextEditingController(
      text: widget.job.client?.phone ?? "",
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
                "Client Details",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
                controller: _nameController,
                validator: (value) =>
                    value!.isEmpty ? "Name is required" : null,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
                controller: _emailController,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Phone",
                ),
                controller: _phoneController,
              ),
              const Spacer(),
              const VerticalDivider(),
              LargeElevatedButton(
                label: "Save",
                onPressed: () => _saveClientDetails(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _saveClientDetails(BuildContext context) async {
    var newClient = widget.job.client ?? Client(name: "New Client");
    if (_formKey.currentState!.validate()) {
      newClient.name = _nameController.text;
      newClient.email = _emailController.text;
      newClient.phone = _phoneController.text;

      await requestErrorHandler(
        context,
        () async {
          var clients = await ref.read(clientsPod.future);

          if (newClient.id == null) {
            var rm = await clients.create(body: newClient.toJson());

            var jobs = await ref.read(jobsPod.future);
            await jobs.update(widget.job.id!, body: {"client": rm.id});
          } else {
            await clients.update(newClient.id!, body: newClient.toJson());
          }
        },
        customMessage: "Error updating client",
      );

      if (context.mounted) {
        ref.invalidate(jobByIdPod(widget.job.id!));
        Navigator.of(context).pop();
      }
    }
  }
}
