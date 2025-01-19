import 'dart:io';

import 'database/account_service.dart';
import 'database/budget_service.dart';
import 'database/cloud_user_service.dart';
import 'database/transaction_category_service.dart';
import 'database/transaction_service.dart';
import 'database/user_service.dart';
import 'package:sqlite3/sqlite3.dart';

const String _createAllTablesQueryString = '''
${CloudUser.createTableSql}
${User.createTableSql}
${Account.createTableSql}
${TransactionCategory.createTableSql}
${Transaction.createTableSql}
${Budget.createTableSql}
''';

late Database _db;

/// Should not be used directly by frontend code. For accessing the databse,
/// use the functions in the `*_service.dart` files in the `database/` folder.
Database get db => _db;

late String _dbPath;

/// Initializes the db variable. Reads the databse (sqlite3) file from the
/// given [path]. If the file does not exists, it will create the file and will
/// initialize the databse
void initializeDatabase({required String path}) {
  _dbPath = path;
  final File file = File(_dbPath);
  if (file.existsSync()) {
    _db = sqlite3.open(_dbPath, mode: OpenMode.readWrite);
  } else {
    _db = sqlite3.open(_dbPath, mode: OpenMode.readWriteCreate);
    db.execute(_createAllTablesQueryString);
  }
}

void closeDatabase() {
  db.dispose();
}

void deleteDatabase() {
  final File file = File(_dbPath);
  if (file.existsSync()) file.deleteSync();
}
