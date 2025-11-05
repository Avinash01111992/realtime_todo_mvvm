import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:realtime_todo_mvvm/src/providers/providers.dart';
import 'package:realtime_todo_mvvm/src/routing/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (kDebugMode) {
    // Route Firestore and Auth to local emulators in debug mode.
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    await fa.FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Realtime TODO',
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: const [
          Breakpoint(start: 0, end: 599, name: MOBILE),
          Breakpoint(start: 600, end: 1023, name: TABLET),
          Breakpoint(start: 1024, end: double.infinity, name: DESKTOP),
        ],
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: const _Gate(),
    );
  }
}

class _Gate extends ConsumerWidget {
  const _Gate();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    return auth.when(
      data: (user) {
        if (user == null) {
          return Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('Tap Continue Anonymously on Sign In screen')),
              ),
            ),
          );
        }
        return Navigator(
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (_) => const _OpenListOnReady(),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Auth error: $e'))),
    );
  }
}

class _OpenListOnReady extends ConsumerWidget {
  const _OpenListOnReady();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.microtask(() {
      final uid = ref.read(firebaseAuthProvider).currentUser!.uid;
      Navigator.of(context).pushReplacementNamed('/list', arguments: uid);
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
