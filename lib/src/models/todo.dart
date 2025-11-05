class TodoItem {
  final String id;
  final String listId;
  final String ownerId;
  final String title;
  final bool completed;
  final DateTime createdAt;

  const TodoItem({
    required this.id,
    required this.listId,
    required this.ownerId,
    required this.title,
    required this.completed,
    required this.createdAt,
  });

  TodoItem copyWith({
    String? title,
    bool? completed,
  }) {
    return TodoItem(
      id: id,
      listId: listId,
      ownerId: ownerId,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'listId': listId,
        'ownerId': ownerId,
        'title': title,
        'completed': completed,
        'createdAt': createdAt.toUtc().millisecondsSinceEpoch,
      };

  factory TodoItem.fromMap(Map<String, dynamic> data) {
    return TodoItem(
      id: data['id'] as String,
      listId: data['listId'] as String,
      ownerId: data['ownerId'] as String,
      title: data['title'] as String,
      completed: (data['completed'] as bool?) ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (data['createdAt'] as num).toInt(),
        isUtc: true,
      ).toLocal(),
    );
  }
}


