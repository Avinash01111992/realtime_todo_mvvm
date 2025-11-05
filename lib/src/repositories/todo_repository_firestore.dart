import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realtime_todo_mvvm/src/models/todo.dart';
import 'package:realtime_todo_mvvm/src/models/todo_list.dart';
import 'package:realtime_todo_mvvm/src/repositories/todo_repository.dart';

class FirestoreTodoRepository implements TodoRepository {
  final FirebaseFirestore _db;
  FirestoreTodoRepository(this._db);

  CollectionReference<Map<String, dynamic>> get listsCol => _db.collection('lists');

  CollectionReference<Map<String, dynamic>> todosCol(String listId) =>
      listsCol.doc(listId).collection('todos');

  @override
  Stream<List<TodoItem>> watchTodos({required String listId, int? limit, Object? startAfter}) {
    Query<Map<String, dynamic>> q = todosCol(listId)
        .orderBy('createdAt', descending: true);
    if (limit != null) q = q.limit(limit);
    if (startAfter != null) q = q.startAfterDocument(startAfter as DocumentSnapshot);

    return q.snapshots().map((snap) => snap.docs
        .map((d) => TodoItem.fromMap({...d.data(), 'id': d.id}))
        .toList());
  }

  @override
  Future<List<TodoItem>> fetchNext({required String listId, required int limit, Object? startAfter}) async {
    Query<Map<String, dynamic>> q = todosCol(listId)
        .orderBy('createdAt', descending: true)
        .limit(limit);
    if (startAfter != null) q = q.startAfterDocument(startAfter as DocumentSnapshot);
    final snap = await q.get();
    return snap.docs.map((d) => TodoItem.fromMap({...d.data(), 'id': d.id})).toList();
  }

  @override
  Future<void> addTodo({required String listId, required String ownerId, required String title}) async {
    await todosCol(listId).add({
      'listId': listId,
      'ownerId': ownerId,
      'title': title,
      'completed': false,
      'createdAt': DateTime.now().toUtc().millisecondsSinceEpoch,
    });
  }

  @override
  Future<void> toggleComplete({required String listId, required String todoId, required bool completed}) async {
    await todosCol(listId).doc(todoId).update({'completed': completed});
  }

  @override
  Future<TodoListMeta> createList({required String ownerId, required String name}) async {
    final doc = await listsCol.add({
      'name': name,
      'ownerId': ownerId,
      'sharedWithUserIds': <String>[],
    });
    return TodoListMeta(id: doc.id, name: name, ownerId: ownerId, sharedWithUserIds: const []);
  }

  @override
  Future<void> shareListWithEmail({required String listId, required String email}) async {
    // For demo, we store emails on list doc; in production resolve email->uid and use security rules.
    await listsCol.doc(listId).set({
      'sharedEmails': FieldValue.arrayUnion([email]),
    }, SetOptions(merge: true));
  }
}


