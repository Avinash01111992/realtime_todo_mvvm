import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtime_todo_mvvm/src/models/todo.dart';
import 'package:realtime_todo_mvvm/src/providers/providers.dart';

class TodoListState {
  final List<TodoItem> items;
  final bool isLoadingMore;
  final Object? cursor;
  const TodoListState({this.items = const [], this.isLoadingMore = false, this.cursor});

  TodoListState copyWith({List<TodoItem>? items, bool? isLoadingMore, Object? cursor}) =>
      TodoListState(items: items ?? this.items, isLoadingMore: isLoadingMore ?? this.isLoadingMore, cursor: cursor ?? this.cursor);
}

class TodoListViewModel extends AutoDisposeNotifier<TodoListState> {
  late final String listId;

  @override
  TodoListState build() {
    state = const TodoListState();
    return state;
  }

  void init({required String listId}) {
    this.listId = listId;
    final repo = ref.read(todoRepositoryProvider);
    ref.listenManual(repo.watchTodos(listId: listId, limit: 20), (prev, next) {
      state = state.copyWith(items: next);
    });
  }

  Future<void> add(String ownerId, String title) async {
    await ref.read(todoRepositoryProvider).addTodo(listId: listId, ownerId: ownerId, title: title);
  }

  Future<void> toggle(String todoId, bool completed) async {
    await ref.read(todoRepositoryProvider).toggleComplete(listId: listId, todoId: todoId, completed: completed);
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore) return;
    state = state.copyWith(isLoadingMore: true);
    // In a fuller impl, track last DocumentSnapshot as cursor. Skipped here.
    state = state.copyWith(isLoadingMore: false);
  }
}

final todoListViewModelProvider = AutoDisposeNotifierProvider<TodoListViewModel, TodoListState>(
  TodoListViewModel.new,
);


