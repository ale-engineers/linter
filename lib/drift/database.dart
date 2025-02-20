import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// テーブル定義
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  BoolColumn get isCompleted => boolean().withDefault(Constant(false))();
}

// データベースクラス
@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // タスクを追加
  Future<int> insertTask(String title) {
    return into(tasks).insert(TasksCompanion(title: Value(title)));
  }

  // タスク一覧を取得（リアルタイム監視）
  Stream<List<Task>> watchAllTasks() {
    return select(tasks).watch();
  }

  // タスクを更新
  Future<void> updateTask(Task task) {
    return update(tasks).replace(task);
  }

  // タスクを削除
  Future<int> deleteTask(int id) {
    return (delete(tasks)..where((t) => t.id.equals(id))).go();
  }
}

// データベース接続を設定
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
