import 'package:flutter/material.dart';
import 'package:realtime_todo_mvvm/src/views/sign_in_view.dart';
import 'package:realtime_todo_mvvm/src/views/todo_list_view.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SignInView());
      case '/list':
        final listId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => TodoListView(listId: listId));
      default:
        return MaterialPageRoute(builder: (_) => const SignInView());
    }
  }
}


