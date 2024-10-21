import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/models/business_details.dart';
import 'package:job_app/models/payment_details.dart';
import 'package:job_app/pages/settings/business_details_form.dart';
import 'package:job_app/pages/settings/payment_details_form.dart';

class DetailsSettings extends ConsumerStatefulWidget {
  final BusinessDetails? business;
  final PaymentDetails? payment;

  const DetailsSettings({
    super.key,
    this.business,
    this.payment,
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
                business: widget.business,
              ),
              PaymentDetailsForm(
                payment: widget.payment,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
