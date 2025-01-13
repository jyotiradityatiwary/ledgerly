import 'dart:io';

import 'accounts_service.dart';
import 'budgets_service.dart';
import 'cloud_user_service.dart';
import 'transaction_category_service.dart';
import 'transaction_service.dart';
import 'user_service.dart';
import 'package:sqlite3/sqlite3.dart';

const String _createTablesQueryString = '''
${CloudUser.createTableSql}
${User.createTableSql}
${Account.createTableSql}
${TransactionCategory.createTableSql}
${Transaction.createTableSql}
${Budget.createTableSql}
''';

late Database _db;
Database get db => _db;

late String _dbPath;

void initializeDatabase({required String path}) {
  _dbPath = path;
  final File file = File(_dbPath);
  if (file.existsSync()) {
    _db = sqlite3.open(_dbPath, mode: OpenMode.readWrite);
  } else {
    _db = sqlite3.open(_dbPath, mode: OpenMode.readWriteCreate);
    db.execute(_createTablesQueryString);
  }
}

void closeDatabase() {
  db.dispose();
}

void deleteDatabase() {
  final File file = File(_dbPath);
  if (file.existsSync()) file.deleteSync();
}
