class AppUser {
  final String uid;
  final String? email;

  const AppUser({required this.uid, this.email});

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
      };

  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
      uid: data['uid'] as String,
      email: data['email'] as String?,
    );
  }
}


