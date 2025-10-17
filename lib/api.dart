import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:job_app/models/client.dart';
import 'package:job_app/models/job.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:riverpod/riverpod.dart';

PocketBase? pb;

const url = String.fromEnvironment("PB_URL");

final pocketBasePod = FutureProvider((ref) async {
  return getPocketBase();
});

final authStorePod = FutureProvider((ref) async {
  var pb = await ref.watch(pocketBasePod.future);

  return pb.authStore;
});

final userPod = FutureProvider((ref) async {
  var pb = await ref.watch(pocketBasePod.future);
  return pb.authStore.record;
});

final userId = FutureProvider((ref) async {
  var auth = await ref.watch(authStorePod.future);

  return auth.record!.id;
});

Future<PocketBase> getPocketBase() async {
  if (pb != null) {
    return pb!;
  } else {
    final prefs = await SharedPreferences.getInstance();

    final store = AsyncAuthStore(
      save: (String data) async => prefs.setString('pb_auth', data),
      initial: prefs.getString('pb_auth'),
    );


    pb = PocketBase(url, authStore: store);

    return pb!;
  }
}

final jobsPod = FutureProvider((ref) async {
  var pb = await ref.watch(pocketBasePod.future);
  return pb.collection('jobs');
});

final jobByIdPod = FutureProvider.family<Job, String>((ref, id) async {
  var pb = await ref.watch(pocketBasePod.future);
  var rm = await pb
      .collection('jobs')
      .getOne(id, expand: "client,materials,attachments,tags,notes");

  return Job.fromRecord(rm);
});

final allJobsPod = FutureProvider<List<Job>>((ref) async {
  var jobCollection = await ref.watch(jobsPod.future);
  var jobRecords = await jobCollection.getFullList(sort: '-scheduledDate');

  return Future.wait([
    for (var job in jobRecords) ref.watch(jobByIdPod(job.id).future),
  ]);
});

final clientsPod = FutureProvider((ref) async {
  var pb = await ref.watch(pocketBasePod.future);
  return pb.collection('clients');
});

final allClientsPod = FutureProvider<List<Client>>((ref) async {
  var clientCollection = await ref.watch(clientsPod.future);
  var clientRecords = await clientCollection.getFullList();

  return clientRecords.map((rm) => Client.fromRecord(rm)).toList();
});

final tagsPod = FutureProvider((ref) async {
  var pb = await ref.watch(pocketBasePod.future);
  return pb.collection('tags');
});

final notesPod = FutureProvider((ref) async {
  var pb = await ref.watch(pocketBasePod.future);
  return pb.collection('notes');
});

final materialsPod = FutureProvider((ref) async {
  var pb = await ref.watch(pocketBasePod.future);
  return pb.collection('materials');
});

final allMaterialsPod = FutureProvider((ref) async {
  var pod = await ref.watch(materialsPod.future);
  return pod.getFullList();
});

final attachmentsPod = FutureProvider((ref) async {
  var pb = await ref.watch(pocketBasePod.future);
  return pb.collection('attachments');
});

final tagColorsPod = FutureProvider((ref) async {
  var pb = await ref.watch(pocketBasePod.future);
  return pb.collection('tag_colors');
});

final allTagColorsPod = FutureProvider((ref) async {
  var pod = await ref.watch(tagColorsPod.future);
  return pod.getFullList();
});

final userDetailsPod = FutureProvider((ref) async {
  var pb = await ref.watch(pocketBasePod.future);
  var uId = await ref.watch(userId.future);

  return pb.collection('users').getOne(uId);
});

Future<void> requestErrorHandler(
    BuildContext context, Future Function() function,
    {String? errorMessage, String? successMessage}) async {
  await function().onError((error, stackTrace) {
    if (context.mounted) {
      if (kDebugMode) {
        print(error.toString());
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage ?? error.toString(),
          ),
        ),
      );

      Navigator.of(context).pop();
    }
  }).whenComplete(() {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage ?? "Request completed."),
        ),
      );
    }
  });
}
