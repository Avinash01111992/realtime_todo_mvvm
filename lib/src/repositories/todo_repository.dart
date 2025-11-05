import 'package:realtime_todo_mvvm/src/models/todo.dart';
import 'package:realtime_todo_mvvm/src/models/todo_list.dart';

abstract class TodoRepository {
  Stream<List<TodoItem>> watchTodos({
    required String listId,
    int? limit,
    Object? startAfter,
  });

  Future<List<TodoItem>> fetchNext({
    required String listId,
    required int limit,
    Object? startAfter,
  });

  Future<void> addTodo({
    required String listId,
    required String ownerId,
    required String title,
  });

  Future<void> toggleComplete({
    required String listId,
    required String todoId,
    required bool completed,
  });

  Future<TodoListMeta> createList({
    required String ownerId,
    required String name,
  });

  Future<void> shareListWithEmail({
    required String listId,
    required String email,
  });
}


