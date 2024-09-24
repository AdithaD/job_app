import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue, brightness: Brightness.dark),
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
              )
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
                                          itemCount: 5,
                                          itemBuilder: (context, index) {
                                            return createJobCard(context);
                                          }),
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

  Widget createJobCard(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("#1 | REF-01-2000"),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Job Name",
                            style: Theme.of(context).textTheme.titleLarge),
                        const Row(
                          children: [
                            Badge(
                              label: Text("TAG"),
                            )
                          ],
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        const Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "John Doe",
                            )
                          ],
                        ),
                        const Row(
                          children: [
                            Icon(Icons.home),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "123 Main St., Anytown USA",
                            )
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
                          Container(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "In Progress",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.calendar_month),
                              Text("09:30 12/12/2024")
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "QUOTED",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [],
            )
          ]),
        ),
      ),
    );
  }
}
