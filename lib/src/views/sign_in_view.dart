import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtime_todo_mvvm/src/providers/providers.dart';

class SignInView extends ConsumerWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await ref.read(authServiceProvider).signInAnonymously();
          },
          child: const Text('Continue Anonymously'),
        ),
      ),
    );
  }
}


