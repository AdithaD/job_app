part of 'view_job_page.dart';

class _MaterialsView extends ConsumerWidget {
  final Job job;
  const _MaterialsView({
    required this.job,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(materialsPod);

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
                  itemCount: job.materials.length,
                  itemBuilder: (context, index) {
                    var mat = job.materials[index];

                    var subTotal = mat.quantity * mat.price;

                    return Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: ListTile(
                              leading: Text(
                                "${mat.quantity}x",
                              ),
                              title: Text(mat.name),
                              subtitle: Text(
                                  "\$${subTotal.toStringAsFixed(2)} (${mat.price})"),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              trailing: SizedBox(
                                width: 96,
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (context) =>
                                              _EditMaterialDialog(
                                            jobId: job.id!,
                                            material: mat,
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    const SizedBox(width: 8.0),
                                    IconButton(
                                      onPressed: () => _deleteMaterial(
                                          context, ref,
                                          material: mat),
                                      icon:
                                          const Icon(Icons.remove_circle_sharp),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (index < job.materials.length - 1)
                          const Divider(
                            thickness: 0.0,
                          ),
                      ],
                    );
                  },
                ),
              ),
              const Divider(),
              ElevatedButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => _EditMaterialDialog(
                        jobId: job.id!,
                        material: JobMaterial(
                          name: "",
                          quantity: 1,
                          price: 1,
                        ),
                      ),
                    );
                  },
                  child: const Text("Add Material"))
            ],
          ),
        ),
      ),
    );
  }

  void _deleteMaterial(BuildContext context, WidgetRef ref,
      {required JobMaterial material}) async {
    var materialCollection = await ref.read(materialsPod.future);
    var jobsCollection = await ref.read(jobsPod.future);

    try {
      await jobsCollection.update(job.id!, body: {"materials-": material.id});

      await materialCollection.delete(material.id!);
      ref.invalidate(jobByIdPod(job.id!));
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString(),
            ),
          ),
        );

        Navigator.of(context).pop();
      }
    }
  }
}

class _EditMaterialDialog extends ConsumerStatefulWidget {
  final String jobId;
  final JobMaterial material;

  const _EditMaterialDialog(
      {super.key, required this.jobId, required this.material});

  @override
  ConsumerState<_EditMaterialDialog> createState() =>
      _EditMaterialDialogState();
}

class _EditMaterialDialogState extends ConsumerState<_EditMaterialDialog> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.material.name,
    );
    _quantityController = TextEditingController(
      text: widget.material.quantity.toString(),
    );
    _priceController = TextEditingController(
      text: widget.material.price.toString(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Form(
          key: formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Edit Material",
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  validator: (value) =>
                      value!.isEmpty ? "Name is required." : null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    hintText: 'Enter the name of the material',
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => validateInt(value, "Quantity", min: 1),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Quantity',
                    hintText: 'Enter the quantity of the material',
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => validateDouble(value, "Price", min: 0),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Price',
                    hintText: 'Enter the price of the material',
                  ),
                ),
                const Divider(),
                LargeElevatedButton(
                  onPressed: () => _saveMaterial(context),
                  label: 'Save Material',
                ),
              ]),
        ),
      ),
    );
  }

  void _saveMaterial(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    var materialCollection = await ref.read(materialsPod.future);
    var jobsCollection = await ref.read(jobsPod.future);

    var newMaterial = widget.material;
    newMaterial.name = _nameController.text;
    newMaterial.quantity = int.parse(_quantityController.text);
    newMaterial.price = double.parse(_priceController.text);

    try {
      if (newMaterial.id == null) {
        newMaterial.owner = await ref.read(userId.future) as String;
        var json = newMaterial.toJson();

        var newMaterialRm = await materialCollection.create(body: json);
        await jobsCollection
            .update(widget.jobId, body: {"materials+": newMaterialRm.id});

        ref.invalidate(materialsPod);
        ref.invalidate(jobByIdPod);
      } else {
        await materialCollection.update(
          newMaterial.id!,
          body: newMaterial.toJson(),
        );
        ref.invalidate(materialsPod);
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString(),
            ),
          ),
        );

        Navigator.of(context).pop();
      }
    }
  }
}
