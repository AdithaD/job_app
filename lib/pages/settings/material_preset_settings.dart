import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/api.dart';
import 'package:job_app/components/large_elevated_button.dart';
import 'package:job_app/components/strings.dart';
import 'package:job_app/models/material_preset.dart';

class MaterialPresetSettings extends ConsumerStatefulWidget {
  const MaterialPresetSettings({
    super.key,
  });

  @override
  ConsumerState<MaterialPresetSettings> createState() =>
      _MaterialPresetSettingsState();
}

class _MaterialPresetSettingsState
    extends ConsumerState<MaterialPresetSettings> {
  var formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController priceController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameController = TextEditingController();
    priceController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var materials = ref.watch(allMaterialsPod).when(
          data: (data) =>
              data.map((e) => MaterialPreset.fromRecord(e)).toList(),
          error: (_, __) => <MaterialPreset>[],
          loading: () => <MaterialPreset>[],
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Material Presets",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 7),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: ListView.builder(
                itemCount: materials.length,
                itemBuilder: (context, index) => MaterialPresetCard(
                  material: materials[index],
                ),
              ),
            ),
          ),
          SizedBox(height: 7),
          Text("Add Material Preset",
              style: Theme.of(context).textTheme.titleSmall),
          SizedBox(height: 15),
          Form(
            key: formKey,
            child: Row(
              children: [
                SizedBox(
                  width: 299,
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Material Name',
                    ),
                  ),
                ),
                const SizedBox(width: 7.0),
                SizedBox(
                  width: 299,
                  child: TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Material Price',
                      ),
                      validator: (value) =>
                          validateDouble(value, "Price", min: -1)),
                ),
                Spacer(),
                ElevatedButton(
                    onPressed: _addMaterialPreset, child: Text("Add Preset"))
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _addMaterialPreset() async {
    if (formKey.currentState!.validate()) {
      await requestErrorHandler(context, () async {
        var materialsCollection = await ref.read(materialsPod.future);
        var owner = await ref.read(userId.future) as String;

        await materialsCollection.create(body: {
          "name": nameController.text,
          "owner": owner,
          "price": double.parse(priceController.text),
        });

        nameController.clear();
        priceController.clear();

        ref.invalidate(allMaterialsPod);
      });
    }
  }
}

class MaterialPresetCard extends ConsumerWidget {
  final MaterialPreset material;

  MaterialPresetCard({super.key, required this.material});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        child: ListTile(
          title: Text(material.name),
          subtitle: Text("\$${material.price.toStringAsFixed(1)}"),
          contentPadding: const EdgeInsets.symmetric(horizontal: 3.0),
          trailing: SizedBox(
            width: 127,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => _EditMaterialPresetDialog(
                        material: material,
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
                const SizedBox(width: 7.0),
                IconButton(
                  onPressed: () =>
                      _deleteMaterial(context, ref, material: material),
                  icon: const Icon(Icons.remove_circle_sharp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteMaterial(BuildContext context, WidgetRef ref,
      {required MaterialPreset material}) async {
    await requestErrorHandler(context, () async {
      var materialsCollection = await ref.read(materialsPod.future);

      await materialsCollection.delete(material.id!);

      ref.invalidate(allMaterialsPod);
    });
  }
}

class _EditMaterialPresetDialog extends ConsumerStatefulWidget {
  final MaterialPreset material;

  const _EditMaterialPresetDialog({required this.material});

  @override
  ConsumerState<_EditMaterialPresetDialog> createState() =>
      _EditMaterialDialogState();
}

class _EditMaterialDialogState
    extends ConsumerState<_EditMaterialPresetDialog> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.material.name,
    );
    _priceController = TextEditingController(
      text: widget.material.price.toString(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          width: 399,
          padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 24),
          child: Form(
            key: formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Edit Material Preset",
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 23),
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
                  const SizedBox(height: 23),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        validateDouble(value, "Price", min: -1),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Price',
                      hintText: 'Enter the price of the material',
                    ),
                  ),
                  const SizedBox(height: 23),
                  const Divider(),
                  LargeElevatedButton(
                    onPressed: () => _saveMaterial(context),
                    label: 'Save Preset',
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Future<void> _saveMaterial(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text;
    final price = double.parse(_priceController.text);

    await requestErrorHandler(context, () async {
      var materialCollection = await ref.read(materialsPod.future);

      await materialCollection.update(widget.material.id!, body: {
        "name": name,
        "price": price,
      });

      ref.invalidate(allMaterialsPod);
    });

    if (context.mounted) Navigator.of(context).pop();
  }
}
