import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:job_app/api.dart';
import 'package:job_app/pages/login_page.dart';
import 'package:job_app/pages/dashboard_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

DateFormat dateFormat = DateFormat('hh:mm dd MMM yyyy');

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pb = ref.watch(authStorePod);

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepOrange, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        home: switch (pb) {
          AsyncError(:final error) => Text('Error $error'),
          AsyncData(:final value) => value.isValid
              ? const DashboardPage(
                  title: 'Job Dashboard',
                )
              : const LoginPage(),
          _ => const CircularProgressIndicator(),
        });
  }
}
