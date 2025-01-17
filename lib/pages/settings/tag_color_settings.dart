import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/api.dart';
import 'package:job_app/components/tag_list.dart';
import 'package:job_app/models/tag.dart';
import 'package:job_app/models/tag_colors.dart';

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
    await requestErrorHandler(
      context,
      () async {
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
      },
      errorMessage: "Error adding tag color",
      successMessage: "Tag color added",
    );
  }

  /// Delete a tag color
  ///
  /// Given a tag color, delete it from the database. This will
  /// also invalidate the allTagColorsPod so that the UI will be
  /// updated.
  void deleteTag(BuildContext context, TagColor tagColor) async {
    await requestErrorHandler(
      context,
      () async {
        var tagColorCollection = await ref.read(tagColorsPod.future);

        await tagColorCollection.delete(tagColor.id!);

        ref.invalidate(allTagColorsPod);
      },
      errorMessage: "Error deleting tag color",
      successMessage: "Tag color deleted",
    );
  }
}
