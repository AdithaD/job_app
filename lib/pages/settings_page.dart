import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/api.dart';
import 'package:job_app/components/tag_list.dart';
import 'package:job_app/models/business_details.dart';
import 'package:job_app/models/tag.dart';
import 'package:job_app/models/tag_colors.dart';
import 'package:job_app/models/user.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref
        .watch(userDetailsPod)
        .mapOrNull(data: (data) => User.fromRecord(data.value));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          bottom: TabBar(tabs: [
            Tab(icon: Icon(Icons.person), child: const Text("Details")),
            Tab(icon: Icon(Icons.color_lens), child: const Text("Colors")),
          ]),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: BusinessDetailsSettings(business: user?.business),
                    ),
                  ),
                  VerticalDivider(),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: PaymentDetailsSettings(),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: TagColorSettings(),
                ),
                VerticalDivider(),
                Flexible(
                  child: Container(),
                ),
                VerticalDivider(),
                Flexible(
                  child: Container(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentDetailsSettings extends StatelessWidget {
  const PaymentDetailsSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class BusinessDetailsSettings extends ConsumerStatefulWidget {
  final BusinessDetails? business;

  const BusinessDetailsSettings({
    super.key,
    this.business,
  });

  @override
  ConsumerState<BusinessDetailsSettings> createState() =>
      _BusinessDetailsSettingsState();
}

class _BusinessDetailsSettingsState
    extends ConsumerState<BusinessDetailsSettings> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _businessNameController;
  late TextEditingController _businessEmailController;
  late TextEditingController _businessPhoneNumberController;
  late TextEditingController _businessABNController;

  late TextEditingController _businessAddressLine1Controller;
  late TextEditingController _businessAddressLine2Controller;
  late TextEditingController _businessAddressLine3Controller;

  @override
  void initState() {
    super.initState();

    var business = widget.business;

    _businessNameController = TextEditingController(
      text: business?.name ?? "",
    );
    _businessEmailController = TextEditingController(
      text: business?.email ?? "",
    );
    _businessPhoneNumberController = TextEditingController(
      text: business?.phoneNumber ?? "",
    );

    _businessAddressLine1Controller = TextEditingController(
      text: business?.addressLine1 ?? "",
    );
    _businessAddressLine2Controller = TextEditingController(
      text: business?.addressLine2 ?? "",
    );
    _businessAddressLine3Controller = TextEditingController(
      text: business?.addressLine3 ?? "",
    );

    _businessABNController = TextEditingController(
      text: business?.abn ?? "",
    );
  }

  @override
  void dispose() {
    super.dispose();

    _businessNameController.dispose();

    _businessEmailController.dispose();
    _businessPhoneNumberController.dispose();

    _businessAddressLine1Controller.dispose();
    _businessAddressLine2Controller.dispose();
    _businessAddressLine3Controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Business Details",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Business Name',
                    ),
                    controller: _businessNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Business Email',
                    ),
                    controller: _businessEmailController,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Business Phone',
                    ),
                    controller: _businessPhoneNumberController,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Business ABN',
                    ),
                    controller: _businessABNController,
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  SizedBox(height: 8),
                  Text(
                    "Business Address",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Line 1',
                    ),
                    controller: _businessAddressLine1Controller,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Line 2',
                    ),
                    controller: _businessAddressLine2Controller,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Line 3',
                    ),
                    controller: _businessAddressLine3Controller,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _saveBusinessDetails(context),
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _saveBusinessDetails(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await requestErrorHandler(context, () async {
        var userCollection =
            (await ref.read(pocketBasePod.future)).collection('users');

        var uId = await ref.read(userId.future);

        var newUser = User.fromRecord(await userCollection.getOne(uId));

        newUser.business = BusinessDetails(
          name: _businessNameController.text,
          email: _businessEmailController.text,
          phoneNumber: _businessPhoneNumberController.text,
          addressLine1: _businessAddressLine1Controller.text,
          addressLine2: _businessAddressLine2Controller.text,
          addressLine3: _businessAddressLine3Controller.text,
          abn: _businessABNController.text,
        );

        await userCollection.update(uId, body: newUser.toJson());

        ref.invalidate(userDetailsPod);
      });
    }
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
                      labelText: "Tag Name",
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
