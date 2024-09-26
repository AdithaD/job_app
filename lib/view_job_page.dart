import 'package:flutter/material.dart';
import 'package:job_app/models.dart';

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
                        Flexible(
                          child: _ViewJobContainer(
                            title: "Details",
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(border: Border.all()),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Row(
                                          children: [
                                            const Icon(Icons.person),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              job.client,
                                            )
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: Row(
                                          children: [
                                            const Icon(Icons.home),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(job.location)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Flexible(
                          child: _ViewJobContainer(
                            title: "Materials",
                            child: Container(
                              color: Colors.orange,
                            ),
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
                    child: Column(
                      children: [
                        Flexible(
                          child: _ViewJobContainer(
                            title: "Schedule",
                            child: Container(
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Flexible(
                          child: _ViewJobContainer(
                            title: "Payment",
                            child: Container(
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Flexible(
                          child: _ViewJobContainer(
                            title: "Attachments",
                            child: Container(
                              color: Colors.orange,
                            ),
                          ),
                        ),
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

class _ViewJobContainer extends StatelessWidget {
  final String title;

  final Widget child;

  const _ViewJobContainer({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
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
