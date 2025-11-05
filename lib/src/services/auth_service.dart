import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:realtime_todo_mvvm/src/models/app_user.dart';

class AuthService {
  final fa.FirebaseAuth _auth;
  AuthService(this._auth);

  Stream<AppUser?> get onAuthStateChanged => _auth.authStateChanges().map(
        (u) => u == null ? null : AppUser(uid: u.uid, email: u.email),
      );

  Future<AppUser> signInAnonymously() async {
    final cred = await _auth.signInAnonymously();
    final u = cred.user!;
    return AppUser(uid: u.uid, email: u.email);
  }

  Future<void> signOut() => _auth.signOut();
}


