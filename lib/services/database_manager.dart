import 'dart:core';
import 'dart:io';

import 'package:ledgerly/model/schemas.dart';
import 'package:ledgerly/model/table_schema.dart';
import 'package:ledgerly/services/crud_services.dart';
import 'package:sqlite3/sqlite3.dart';
import 'dart:developer' as developer;

final List<TableSchema> _allSchema = [
  accountSchema,
  budgetSchema,
  cloudUserSchema,
  transactionCategorySchema,
  transactionSchema,
  userSchema,
];

Database? _db;
Database getDbInstance() => dbHandle;

class DatabaseNotOpenError extends Error {}

/// Should not be used directly by frontend code. For accessing the databse,
/// use the functions in the `*_service.dart` files in the `database/` folder.
Database get dbHandle {
  if (_db == null) throw DatabaseNotOpenError();
  return _db!;
}

late String _dbPath;

/// Initializes the db variable. Reads the databse (sqlite3) file from the
/// given [path]. If the file does not exists, it will create the file and will
/// initialize the databse
void initializeDatabase({required String path}) {
  _dbPath = path;
  final File file = File(_dbPath);

  // open the databse in read/write mode. Create the databse file if required
  _db = sqlite3.open(
    _dbPath,
    mode: file.existsSync() ? OpenMode.readWrite : OpenMode.readWriteCreate,
  );

  // initialize tables if required
  if (!_areTablesInitialized()) _initializeTables();
}

bool _areTablesInitialized() {
  final sql = "SELECT name FROM sqlite_master WHERE type=? AND name=?";
  final ResultSet resultSet = dbHandle.select(sql, [
    'table',
    _allSchema.first.tableName,
  ]);
  assert(resultSet.isEmpty || resultSet.length == 1);
  return resultSet.isNotEmpty;
}

void _initializeTables() {
  // merge `createTableSql` from all `schema`s
  final createAllTablesQueryString =
      _allSchema.map((schema) => schema.createTableSql).join('\n');

  // create and open the database file
  _db = sqlite3.open(_dbPath, mode: OpenMode.readWriteCreate);

  // initialize all tables in a single transaction
  dbHandle.execute(createAllTablesQueryString);
  developer.log("tables initialized");
}

void closeDatabase() {
  dbHandle.dispose();

  _db = null;
}

void deleteDatabase() {
  final File file = File(_dbPath);
  if (file.existsSync()) file.deleteSync();
}
