import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtime_todo_mvvm/src/models/app_user.dart';
import 'package:realtime_todo_mvvm/src/providers/providers.dart';
import 'package:realtime_todo_mvvm/src/viewmodels/todo_list_viewmodel.dart';
import 'package:realtime_todo_mvvm/src/widgets/todo_item_tile.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class TodoListView extends ConsumerStatefulWidget {
  final String listId;
  const TodoListView({super.key, required this.listId});

  @override
  ConsumerState<TodoListView> createState() => _TodoListViewState();
}

class _TodoListViewState extends ConsumerState<TodoListView> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(todoListViewModelProvider.notifier).init(listId: widget.listId);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider).value;
    final state = ref.watch(todoListViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Realtime TODOs'),
        actions: [
          IconButton(
            onPressed: () {
              final shareText = 'Join my Todo List: ${widget.listId}';
              Share.share(shareText);
            },
            icon: const Icon(Icons.share),
            tooltip: 'Share list id',
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Add a task...'),
                    onSubmitted: (_) => _add(auth),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () => _add(auth), child: const Text('Add'))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return TodoItemTile(
                  item: item,
                  onChanged: (value) => ref.read(todoListViewModelProvider.notifier).toggle(item.id, value ?? false),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: 'Share with email'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _shareByEmail,
                  child: const Text('Invite'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _add(AppUser? auth) async {
    if (auth == null) return;
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    await ref.read(todoListViewModelProvider.notifier).add(auth.uid, text);
    _controller.clear();
  }

  Future<void> _shareByEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;
    final uri = Uri(scheme: 'mailto', path: email, queryParameters: {
      'subject': 'Join my Todo List',
      'body': 'Use list id: ${widget.listId}',
    });
    await launchUrl(uri);
  }
}


