import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'database.g.dart';

// Table definition for todo items with indexing on title
@TableIndex(name: 'todo', columns: {#title})
class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  BoolColumn get dbData => boolean()();
}

// Drift database class that manages todo items
@DriftDatabase(tables: [TodoItems])
class Database extends _$Database {
  // Initialize the database connection
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 2; // Database schema version

  // Fetch all tasks from the todoItems table
  Future<List<TodoItem>> getTasks() async {
    return await select(todoItems).get();
  }

  // Update a todo task in the database
  Future<bool> updateTask(TodoItem task) async {
    return await update(todoItems).replace(task);
  }

  // Insert a new task into the database
  Future<int> insertTask(String title) async {
    return await into(todoItems).insert(
        TodoItemsCompanion(title: Value(title), dbData: const Value(true)));
  }

  // Delete a task from the database by its ID
  Future<int> deleteTask(int id) async {
    return await (delete(todoItems)..where((tbl) => tbl.id.equals(id))).go();
  }
}

// open when the database is first requested to be opened
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Path for the SQLite database file
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'tasks.sqlite'));

    return NativeDatabase(file); // Open the native database
  });
}
