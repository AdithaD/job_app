import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_app/components/job_status_badge.dart';
import 'package:job_app/components/payment_status_badge.dart';
import 'package:job_app/models.dart';
import 'package:job_app/view_job_page.dart';

void main() {
  runApp(const MyApp());
}

DateFormat dateFormat = DateFormat('hh:mm dd MMM yyyy');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.archive),
                label: Text('Archive'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Clients'),
              ),
            ],
            selectedIndex: 0,
            labelType: NavigationRailLabelType.all,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Job Dashboard",
                            style: Theme.of(context).textTheme.displayLarge),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        // Upcoming Jobs
                        Flexible(
                          flex: 1,
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Upcoming jobs"),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.filter_alt)),
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.sort))
                                      ],
                                    ),
                                  ]),
                              Expanded(
                                child: Container(
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListView.builder(
                                        itemCount: sampleJobs.length,
                                        itemBuilder: (context, index) {
                                          var job = sampleJobs[index];
                                          return InkWell(
                                              onTap: () =>
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewJobPage(job: job),
                                                    ),
                                                  ),
                                              child: JobCard(job: job));
                                        },
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Maps
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(border: Border.all()),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _incrementCounter,
        tooltip: 'Add job',
        label: const Text('Add job'),
        icon: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class JobCard extends StatelessWidget {
  final Job job;

  const JobCard({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("#${job.id}"),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job.title,
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: job.tags
                              .map((tag) => Badge(
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    label: Text(tag),
                                  ))
                              .expand((b) => [b, const SizedBox(width: 8)])
                              .toList(),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.person),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(job.client.name),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.home),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(job.location)
                          ],
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          JobStatusBadge(status: job.jobStatus),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.calendar_month),
                              Text(dateFormat.format(job.scheduledDate!)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          PaymentStatusBadge(status: job.paymentStatus),
                          Expanded(child: Container()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit))
                            ],
                          ),
                        ],
                      ))
                ],
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [],
            )
          ]),
        ),
      ),
    );
  }
}
