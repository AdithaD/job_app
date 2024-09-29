import 'dart:io';

import 'package:flutter/material.dart';
import 'package:job_app/components/job_status_badge.dart';
import 'package:job_app/components/payment_status_badge.dart';
import 'package:job_app/main.dart';
import 'package:job_app/models.dart';
import 'package:intl/intl.dart';

class ViewJobPage extends StatelessWidget {
  final Job job;

  const ViewJobPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 120,
          leading: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(
            job.title,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Details",
                icon: Icon(Icons.list_alt),
              ),
              Tab(
                text: "Pricing",
                icon: Icon(Icons.attach_money),
              ),
              Tab(
                text: "Attachments",
                icon: Icon(Icons.attach_file),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 32.0),
          child: TabBarView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              _DetailsView(job: job),
                              const SizedBox(
                                width: 16,
                              ),
                              Flexible(
                                child: _ClientDetailsView(job: job),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              _ScheduleView(job: job),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 48.0,
                        ),
                        // Schedule, Quote, Attachments
                      ],
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Row(
                  children: [
                    _MaterialsView(job: job),
                    const SizedBox(
                      width: 16,
                    ),
                    _PaymentView(job: job),
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  children: [
                    _AttachmentsView(job: job),
                    const SizedBox(
                      width: 16,
                    ),
                    _NotesView(job: job),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClientDetailsView extends StatelessWidget {
  final Job job;
  const _ClientDetailsView({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: _ViewJobContainer(
        title: "Client",
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ViewField(
                fieldName: "Name",
                child: Text(job.client.name),
              ),
              SizedBox(
                height: 16,
              ),
              ViewField(
                fieldName: "Email",
                child: Text(job.client.email ?? ""),
              ),
              SizedBox(
                height: 16,
              ),
              ViewField(
                fieldName: "Phone",
                child: Text(job.client.phone ?? ""),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotesView extends StatelessWidget {
  final Job job;
  const _NotesView({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: _ViewJobContainer(
        title: "Notes",
        showEditButton: false,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(""),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachmentsView extends StatelessWidget {
  final Job job;
  const _AttachmentsView({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: _ViewJobContainer(
        title: "Attachments",
        showEditButton: false,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var att = job.attachments[index];

                    var title = att.url.substring(att.url.lastIndexOf("/") + 1);

                    if (att.name != null) {
                      title = att.name!;
                    }

                    return ListTile(
                      title: Text(title),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 4.0),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete),
                      ),
                    );
                  },
                  itemCount: job.attachments.length,
                ),
              ),
              const Divider(),
              ElevatedButton(
                  onPressed: () {}, child: const Text("Add Attachment"))
            ],
          ),
        ),
      ),
    );
  }
}

class _MaterialsView extends StatelessWidget {
  final Job job;
  const _MaterialsView({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
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
                  itemBuilder: (context, index) {
                    var mat = job.materials[index];

                    var subTotal = mat.quantity * mat.price;

                    return Column(
                      children: [
                        ListTile(
                          leading: Text(
                            "${mat.quantity}x",
                          ),
                          title: Text(mat.name),
                          subtitle: Text(
                              "\$${subTotal.toStringAsFixed(2)} (${mat.price})"),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.remove_circle_sharp),
                          ),
                        ),
                        if (index < job.materials.length - 1)
                          const Divider(
                            thickness: 0.0,
                          ),
                      ],
                    );
                  },
                  itemCount: job.attachments.length,
                ),
              ),
              const Divider(),
              ElevatedButton(
                  onPressed: () {}, child: const Text("Add Material"))
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentView extends StatelessWidget {
  final Job job;

  const _PaymentView({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: _ViewJobContainer(
        title: "Payment",
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ViewField(
                fieldName: "Status",
                child: PaymentStatusBadge(status: job.paymentStatus),
              ),
              const SizedBox(
                height: 16,
              ),
              if (job.quotedPrice != null)
                ViewField(
                    fieldName: "Amount",
                    child: Text("\$${job.quotedPrice!.toStringAsFixed(2)}")),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {}, child: const Text("Generate Quote")),
                  ElevatedButton(
                      onPressed: () {}, child: const Text("Generate Invoice"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ScheduleView extends StatelessWidget {
  final Job job;

  const _ScheduleView({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: _ViewJobContainer(
        title: "Schedule",
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ViewField(
                  fieldName: "Status",
                  child: JobStatusBadge(status: job.jobStatus)),
              const SizedBox(
                height: 16,
              ),
              if (job.scheduledDate != null)
                ViewField(
                  fieldName: "Scheduled Date",
                  child: Text(
                    dateFormat.format(job.scheduledDate!),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailsView extends StatelessWidget {
  const _DetailsView({
    super.key,
    required this.job,
  });

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: _ViewJobContainer(
        title: "Details",
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ViewField(
                fieldName: "Tags",
                child: Row(
                  children: job.tags
                      .map(
                        (tag) => Badge(
                          backgroundColor: Colors.blue,
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              tag,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                      )
                      .expand((b) => [b, const SizedBox(width: 8)])
                      .toList(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ViewField(
                        fieldName: "Location", child: Text(job.location)),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                  child: ViewField(
                      fieldName: "Description",
                      child: Text(job.description ?? ""))),
            ],
          ),
        ),
      ),
    );
  }
}

class ViewField extends StatelessWidget {
  const ViewField({
    super.key,
    required this.fieldName,
    required this.child,
  });

  final String fieldName;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(fieldName, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(
          height: 8,
        ),
        child
      ],
    );
  }
}

class _ViewJobContainer extends StatelessWidget {
  final String title;

  final Widget child;
  final bool showEditButton;

  const _ViewJobContainer(
      {required this.title, required this.child, this.showEditButton = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              if (showEditButton)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {},
                ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: child,
        ),
      ],
    );
  }
}
