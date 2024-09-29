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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        leading: IconButton(
          onPressed: () {},
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
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
            const SizedBox(
              height: 16.0,
            ),
            Expanded(
              child: Row(
                children: [
                  // Details and Materials
                  Flexible(
                    child: Column(
                      children: [
                        _DetailsView(job: job),
                        const SizedBox(
                          height: 16,
                        ),
                        Flexible(
                          child: Row(
                            children: [
                              _ScheduleView(job: job),
                              const SizedBox(
                                width: 16,
                              ),
                              _PaymentView(job: job),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 48.0,
                  ),
                  // Schedule, Quote, Attachments
                  Flexible(
                    child: Row(
                      children: [
                        _MaterialsView(job: job),
                        const SizedBox(
                          width: 16,
                        ),
                        _AttachmentsView(job: job),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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

                    return ListTile(
                      leading: Text("${mat.quantity}x"),
                      title: Text(mat.name),
                      subtitle: Text("\$${subTotal.toStringAsFixed(2)}"),
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
                    child: Text("\$${job.quotedPrice!.toString()}")),
              Expanded(child: Container()),
              Row(
                children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ViewField(
                      fieldName: "Client",
                      child: Text(job.client),
                    ),
                  ),
                  const SizedBox(
                    width: 32,
                  ),
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
        Text(fieldName, style: Theme.of(context).textTheme.labelSmall),
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
        Row(
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
