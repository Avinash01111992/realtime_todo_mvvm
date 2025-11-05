import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtime_todo_mvvm/src/models/app_user.dart';
import 'package:realtime_todo_mvvm/src/repositories/todo_repository.dart';
import 'package:realtime_todo_mvvm/src/repositories/todo_repository_firestore.dart';
import 'package:realtime_todo_mvvm/src/services/auth_service.dart';

final firebaseAuthProvider = Provider<fa.FirebaseAuth>((ref) => fa.FirebaseAuth.instance);
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref.read(firebaseAuthProvider)));

final authStateProvider = StreamProvider<AppUser?>((ref) => ref.read(authServiceProvider).onAuthStateChanged);

final todoRepositoryProvider = Provider<TodoRepository>((ref) => FirestoreTodoRepository(ref.read(firestoreProvider)));


