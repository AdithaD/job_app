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
                                width: 128,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (context) =>
                                              _EditMaterialDialog(
                                            job: job,
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
                        job: job,
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
    var jobsCollection = await ref.read(jobsPod.future);

    try {
      var newMaterials = job.materials
          .where((element) => element.name != material.name)
          .toList();
      await jobsCollection.update(job.id!, body: {"materials": newMaterials});

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
  final Job job;
  final JobMaterial material;

  const _EditMaterialDialog({required this.job, required this.material});

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
    var materialsPresets = ref.watch(allMaterialsPod);

    return Dialog(
      child: SingleChildScrollView(
        child: Row(
          children: [
            Flexible(
              child: Container(
                width: 800,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
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
                          onChanged: (value) => setState(() {}),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) => validateInt(
                            value,
                            "Quantity",
                          ),
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
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) =>
                              validateDouble(value, "Price", min: 0),
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
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: SizedBox(
                  height: 400,
                  child: materialsPresets.when(
                    data: (data) {
                      var filteredData = data
                          .map((rm) => MaterialPreset.fromRecord(rm))
                          .where((element) => element.name
                              .toLowerCase()
                              .contains(_nameController.text.toLowerCase()))
                          .toList();

                      return ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          var material = filteredData[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(material.name),
                                subtitle: Text(
                                    "\$${material.price.toStringAsFixed(2)}"),
                                onTap: () {
                                  _nameController.text = material.name;
                                  _priceController.text =
                                      material.price.toString();
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) => Text(error.toString()),
                    loading: () =>
                        Center(child: const CircularProgressIndicator()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveMaterial(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    var jobsCollection = await ref.read(jobsPod.future);

    var newMaterial = widget.material;
    newMaterial.name = _nameController.text;
    newMaterial.quantity = int.parse(_quantityController.text);
    newMaterial.price = double.parse(_priceController.text);

    if (context.mounted) {
      await requestErrorHandler(
        context,
        () async {
          var materials = widget.job.materials
              .where((m) => m.name != newMaterial.name)
              .toList();
          materials.add(newMaterial);

          await jobsCollection
              .update(widget.job.id!, body: {"materials": materials});

          ref.invalidate(jobByIdPod(widget.job.id!));
        },
        successMessage: "Material saved.",
        errorMessage: "Error saving material.",
      );
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
