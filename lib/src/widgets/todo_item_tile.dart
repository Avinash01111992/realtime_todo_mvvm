import 'package:flutter/material.dart';
import 'package:realtime_todo_mvvm/src/models/todo.dart';

class TodoItemTile extends StatelessWidget {
  final TodoItem item;
  final ValueChanged<bool?> onChanged;
  const TodoItemTile({super.key, required this.item, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(item.title),
      value: item.completed,
      onChanged: onChanged,
    );
  }
}


