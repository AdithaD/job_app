import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/api.dart';
import 'package:job_app/models/tag.dart';
import 'package:job_app/models/tag_colors.dart';

class TagList extends ConsumerWidget {
  final List<Tag> tags;

  const TagList({
    super.key,
    required this.tags,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tagColors = ref
        .watch(allTagColorsPod)
        .when(
            data: (data) => data.map((e) => TagColor.fromRecord(e)),
            error: (_, __) => <TagColor>[],
            loading: () => <TagColor>[])
        .toList();

    return Row(
      children: tags
          .map(
            (tag) => TagWidget(
              tag: tag,
              color: _getColor(tag, tagColors),
            ),
          )
          .expand((b) => [b, const SizedBox(width: 8)])
          .toList(),
    );
  }

  /// Return the color for the tag, using the color from the color overrides if
  /// the tag name matches the name in the overrides. If there is no match, use
  /// a default color of blue.
  Color _getColor(Tag tag, List<TagColor> colorOverrides) {
    Color color = Colors.blue;
    for (var c in colorOverrides) {
      if (c.name == tag.name) {
        color = Color(c.color);
        break;
      }
    }

    return color;
  }
}

class TagWidget extends StatelessWidget {
  final Tag tag;
  final Color color;
  const TagWidget({
    super.key,
    required this.tag,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Text(
        tag.name,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
