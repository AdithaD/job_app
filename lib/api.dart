import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:riverpod/riverpod.dart';

PocketBase? pb;

final pocketBasePod = FutureProvider((ref) async {
  return getPocketBase();
});

final authStorePod = FutureProvider((ref) async {
  var pb = await ref.watch(pocketBasePod.future);

  return pb.authStore;
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

    pb = PocketBase('http://localhost:8090', authStore: store);

    return pb!;
  }
}

final jobsPod = FutureProvider((ref) async {
  var pb = await ref.watch(pocketBasePod.future);
  return pb
      .collection('jobs')
      .getFullList(expand: "client,materials,attachments,tags");
});
