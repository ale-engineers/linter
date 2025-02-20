import 'package:flutter/material.dart';

import 'database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppDatabase database = AppDatabase();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskScreen(database: database),
    );
  }
}

class TaskScreen extends StatelessWidget {
  final AppDatabase database;
  TaskScreen({super.key, required this.database});

  final TextEditingController _taskController = TextEditingController();

  // タスクを追加
  Future<void> _addTask() async {
    if (_taskController.text.isNotEmpty) {
      await database.insertTask(_taskController.text);
      _taskController.clear();
    }
  }

  // タスクを更新（完了状態をトグル）
  Future<void> _toggleTask(Task task) async {
    await database.updateTask(task.copyWith(isCompleted: !task.isCompleted));
  }

  // タスクを削除
  Future<void> _deleteTask(int id) async {
    await database.deleteTask(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Drift Tasks')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(labelText: 'Add Task'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTask,
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: database.watchAllTasks(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                final tasks = snapshot.data!;
                if (tasks.isEmpty) return Center(child: Text('No tasks yet'));

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => _toggleTask(task),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteTask(task.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
