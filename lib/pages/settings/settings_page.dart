import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/api.dart';
import 'package:job_app/components/large_elevated_button.dart';
import 'package:job_app/components/strings.dart';
import 'package:job_app/components/tag_list.dart';
import 'package:job_app/models/material_preset.dart';
import 'package:job_app/models/tag.dart';
import 'package:job_app/models/tag_colors.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/pages/settings/details_settings.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var user = ref
        .watch(userDetailsPod)
        .mapOrNull(data: (data) => User.fromRecord(data.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        bottom: TabBar(tabs: [
          Tab(icon: Icon(Icons.person), child: const Text("Details")),
          Tab(icon: Icon(Icons.list), child: const Text("Presets")),
        ], controller: _tabController),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: DetailsSettings(
                      business: user?.business,
                      payment: user?.payment,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              children: [
                Flexible(
                  child: TagColorSettings(),
                ),
                VerticalDivider(),
                Flexible(
                  flex: 2,
                  child: MaterialPresetSettings(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Material Presets",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
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
          SizedBox(height: 8),
          Text("Add Material Preset",
              style: Theme.of(context).textTheme.titleSmall),
          SizedBox(height: 16),
          Form(
            key: formKey,
            child: Row(
              children: [
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Material Name',
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Material Price',
                      ),
                      validator: (value) =>
                          validateDouble(value, "Price", min: 0)),
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListTile(
          title: Text(material.name),
          subtitle: Text("\$${material.price.toStringAsFixed(2)}"),
          contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          trailing: SizedBox(
            width: 128,
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
                const SizedBox(width: 8.0),
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
          width: 400,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Form(
            key: formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Edit Material Preset",
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
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        validateDouble(value, "Price", min: 0),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Price',
                      hintText: 'Enter the price of the material',
                    ),
                  ),
                  const SizedBox(height: 24),
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

class TagColorSettings extends ConsumerStatefulWidget {
  const TagColorSettings({
    super.key,
  });

  @override
  ConsumerState<TagColorSettings> createState() => _TagColorSettingsState();
}

class _TagColorSettingsState extends ConsumerState<TagColorSettings> {
  Color _selectedColor = Colors.blue;
  late TextEditingController _nameController;

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
    var tagColors = ref.watch(allTagColorsPod).when(
          data: (data) => data.map((e) => TagColor.fromRecord(e)).toList(),
          error: (_, __) => <TagColor>[],
          loading: () => <TagColor>[],
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Tag Colors",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 8),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: ListView.builder(
              itemCount: tagColors.length,
              itemBuilder: (context, index) {
                var tagColor = tagColors[index];

                return Column(
                  children: [
                    Row(
                      children: [
                        TagWidget(
                          tag: Tag(name: tagColor.name),
                          color: Color(tagColor.color),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteTag(context, tagColor),
                        ),
                      ],
                    ),
                    Divider()
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Set Tag",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickColour,
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: _selectedColor,
                        border: Border.all(),
                      ),
                      height: 30,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                  onPressed: () => addTag(context),
                  child: Text("Add"),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  void _pickColour() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: MaterialPicker(
            pickerColor: _selectedColor,
            onColorChanged: (newColor) =>
                setState(() => _selectedColor = newColor),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          )
        ],
      ),
    );
  }

  void addTag(BuildContext context) async {
    await requestErrorHandler(context, () async {
      var tagName = _nameController.text;

      if (tagName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Tag name cannot be empty"),
          ),
        );
        return;
      }

      var tagColorCollection = await ref.read(tagColorsPod.future);

      await tagColorCollection.create(
        body: {
          "owner": await ref.read(userId.future) as String,
          "name": tagName,
          "color": _selectedColor.value,
        },
      );

      ref.invalidate(allTagColorsPod);
    });
  }

  /// Delete a tag color
  ///
  /// Given a tag color, delete it from the database. This will
  /// also invalidate the allTagColorsPod so that the UI will be
  /// updated.
  void deleteTag(BuildContext context, TagColor tagColor) async {
    await requestErrorHandler(context, () async {
      var tagColorCollection = await ref.read(tagColorsPod.future);

      await tagColorCollection.delete(tagColor.id!);

      ref.invalidate(allTagColorsPod);
    });
  }
}
