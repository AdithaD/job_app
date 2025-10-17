import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/pages/settings/details_settings.dart';
import 'package:job_app/pages/settings/material_preset_settings.dart';
import 'package:job_app/pages/settings/tag_color_settings.dart';

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
                    child: DetailsSettings(),
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
