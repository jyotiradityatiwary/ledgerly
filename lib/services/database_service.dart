import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

const String _createTablesQueryString = '''
CREATE TABLE CloudUsers (
  cloud_user_id INTEGER PRIMARY KEY,
  server_address TEXT NOT NULL,
  identifier TEXT NOT NULL,
  last_sync_datetime INTEGER NOT NULL,
  login_expiry_datetime INTEGER NOT NULL
);

CREATE TABLE Users (
  user_id INTEGER PRIMARY KEY,
  user_name TEXT NOT NULL,
  currency_precision INT NOT NULL,
  currency TEXT NOT NULL,
  cloud_user_id INTEGER DEFAULT NULL UNIQUE REFERENCES CloudUsers(cloud_user_id)
);

CREATE TABLE Accounts (
  account_id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES Users(user_id),
  initial_balance INTEGER NOT NULL,
  current_balance INTEGER NOT NULL, -- derived
  account_description TEXT DEFAULT NULL
);

CREATE TABLE TransactionCategories (
  category_id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES Users(user_id),
  category_name TEXT NOT NULL,
  category_type INTEGER NOT NULL,
  category_description TEXT DEFAULT NULL
);

CREATE TABLE Transactions (
    transaction_id INTEGER PRIMARY KEY,
    source_account_id INTEGER NOT NULL REFERENCES Accounts(account_id),
    destination_account_id INTEGER NOT NULL REFERENCES Accounts(account_id),
    amount INTEGER NOT NULL,
    transaction_summary TEXT NOT NULL,
    transaction_description TEXT DEFAULT NULL,
    transaction_datetime INTEGER NOT NULL
);

CREATE TABLE Budgers (
    budget_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES Users(user_id),
    category_id INTEGER NOT NULL REFERENCES TransactionCategories(category_id),
    budget_amount INTEGER NOT NULL,
    start_datetime INTEGER NOT NULL,
    end_datetime INTEGER DEFAULT NULL,
    recurrency_days INTEGER NOT NULL,
    budget_name TEXT NOT NULL,
    budget_description TEXT DEFAULT NULL
);
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
