import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

class SqliteDatabase {
  SqliteDatabase._(this.database);

  final Database database;

  static SqliteDatabase open({
    required String databasePath,
  }) {
    final file = File(databasePath);
    file.parent.createSync(recursive: true);

    final db = sqlite3.open(p.normalize(databasePath));
    return SqliteDatabase._(db);
  }

  void close() => database.dispose();
}
