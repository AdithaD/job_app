import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/api.dart';
import 'package:job_app/models/tag_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          bottom: TabBar(tabs: [
            Tab(icon: Icon(Icons.color_lens), child: const Text("Colors")),
          ]),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: TabBarView(
            children: [
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
      ),
    );
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
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: ListView.builder(
              itemCount: tagColors.length,
              itemBuilder: (context, index) {
                var tagColor = tagColors[index];

                return Row(
                  children: [
                    Text(
                      tagColor.name,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Color(tagColor.color),
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteTag(context, tagColor),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Divider(),
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
              width: 8,
            ),
            Expanded(
              child: GestureDetector(
                onTap: _pickColour,
                child: Container(
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    border: Border.all(),
                  ),
                  height: 40,
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            ElevatedButton(
              onPressed: () => addTag(context),
              child: Text("Add"),
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
