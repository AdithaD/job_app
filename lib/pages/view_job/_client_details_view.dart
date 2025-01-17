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
                  Text("No client details",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontStyle: FontStyle.italic)),
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
                  ViewField(
                    fieldName: "Address",
                    child: Text(
                        "${client.addressLine1 ?? ""}\n${client.addressLine2 ?? ""}\n${client.addressLine3 ?? ""}"),
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

  const _ClientDetailsEditDialog({required this.job});

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

  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _addressLine3Controller;

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

    _addressLine1Controller = TextEditingController(
      text: widget.job.client?.addressLine1 ?? "",
    );
    _addressLine2Controller = TextEditingController(
      text: widget.job.client?.addressLine2 ?? "",
    );
    _addressLine3Controller = TextEditingController(
      text: widget.job.client?.addressLine3 ?? "",
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
      child: SingleChildScrollView(
        child: Container(
          height: 650,
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
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Address Line 1",
                  ),
                  controller: _addressLine1Controller,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Address Line 2",
                  ),
                  controller: _addressLine2Controller,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Address Line 3",
                  ),
                  controller: _addressLine3Controller,
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
      ),
    );
  }

  void _saveClientDetails(BuildContext context) async {
    var newClient = widget.job.client ?? Client(name: "New Client");
    if (_formKey.currentState!.validate()) {
      newClient.name = _nameController.text;
      newClient.email = _emailController.text;
      newClient.phone = _phoneController.text;

      newClient.addressLine1 = _addressLine1Controller.text;
      newClient.addressLine2 = _addressLine2Controller.text;
      newClient.addressLine3 = _addressLine3Controller.text;

      await requestErrorHandler(
        context,
        () async {
          var clients = await ref.read(clientsPod.future);

          if (newClient.id == null) {
            newClient.owner = await ref.read(userId.future) as String;
            var rm = await clients.create(body: newClient.toJson());

            var jobs = await ref.read(jobsPod.future);
            await jobs.update(widget.job.id!, body: {"client": rm.id});
          } else {
            await clients.update(newClient.id!, body: newClient.toJson());
          }
        },
        errorMessage: "Error updating client details",
        successMessage: "Client details updated",
      );

      if (context.mounted) {
        ref.invalidate(jobByIdPod(widget.job.id!));
        Navigator.of(context).pop();
      }
    }
  }
}
