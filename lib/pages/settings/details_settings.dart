import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/api.dart';
import 'package:job_app/models/business_details.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/pages/settings/business_details_form.dart';
import 'package:job_app/pages/settings/payment_details_form.dart';

class DetailsSettings extends ConsumerStatefulWidget {
  const DetailsSettings({
    super.key,
  });

  @override
  ConsumerState<DetailsSettings> createState() => _DetailsSettingsState();
}

class _DetailsSettingsState extends ConsumerState<DetailsSettings>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = ref
        .watch(userDetailsPod)
        .whenOrNull(data: (data) => User.fromRecord(data));

    return Column(
      children: [
        TabBar.secondary(
          tabs: const [
            Tab(text: "Business"),
            Tab(text: "Payment"),
            //Tab(text: "Payment"),
          ],
          controller: _tabController,
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              BusinessDetailsForm(
                business: userDetails?.business,
              ),
              PaymentDetailsForm(
                payment: userDetails?.payment,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
