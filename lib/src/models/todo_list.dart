class TodoListMeta {
  final String id;
  final String name;
  final String ownerId;
  final List<String> sharedWithUserIds; // users who can edit

  const TodoListMeta({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.sharedWithUserIds,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'ownerId': ownerId,
        'sharedWithUserIds': sharedWithUserIds,
      };

  factory TodoListMeta.fromMap(Map<String, dynamic> data) {
    return TodoListMeta(
      id: data['id'] as String,
      name: data['name'] as String,
      ownerId: data['ownerId'] as String,
      sharedWithUserIds: (data['sharedWithUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );
  }
}


