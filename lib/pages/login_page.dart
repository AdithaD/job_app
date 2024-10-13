import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/api.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  Future<void> _login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final pbPod = ref.read(pocketBasePod);

    if (pbPod.hasValue) {
      final pb = pbPod.value!;

      try {
        await pb.collection("users").authWithPassword(username, password);
        ref.invalidate(pocketBasePod);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }

        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300.0,
          height: 300.0,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Login',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      controller: _usernameController,
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      controller: _passwordController,
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    FilledButton(
                        onPressed: () => _login(context),
                        child: const Text("Login"))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
