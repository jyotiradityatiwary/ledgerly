// CREATE TABLE Users (
//   user_id INTEGER PRIMARY KEY,
//   user_name TEXT NOT NULL,
//   currency_precision INT NOT NULL,
//   currency TEXT NOT NULL,
//   cloud_user_id INTEGER DEFAULT NULL UNIQUE REFERENCES CloudUsers(cloud_user_id)
// )

import 'package:ledgerly/services/database_service.dart';
import 'package:sqlite3/sqlite3.dart';

class CloudUser {
  final int id;
  final String serverAddress;
  final String identifier;
  final DateTime lastSync;
  final DateTime loginExpiry;

  CloudUser({
    required this.id,
    required this.serverAddress,
    required this.identifier,
    required this.lastSync,
    required this.loginExpiry,
  });
}

class User {
  int id;
  String name;
  int currencyPrecision;
  String currency;
  CloudUser? cloudUser;

  User({
    required this.id,
    required this.name,
    required this.currencyPrecision,
    required this.currency,
    this.cloudUser,
  });

  static User fromRow(final Row row) => User(
        id: row.columnAt(0),
        name: row.columnAt(1),
        currencyPrecision: row.columnAt(2),
        currency: row.columnAt(3),
        cloudUser: row.columnAt(4),
      );

  static const sqlCols =
      'user_id, user_name, currency_precision, currency, cloud_user_id';
  static const sqlColsQuestions = '?, ?, ?, ?, ?';

  @override
  int get hashCode => id;
  @override
  bool operator ==(final Object other) => other is User && id == other.id;
}

List<int> getAllUserIds() {
  const String sql = 'SELECT ROWID FROM Users;';
  final ResultSet results = db.select(sql);
  return [for (Row row in results) row.columnAt(0) as int];
}

List<User> getAllUsers() {
  const String sql = 'SELECT ${User.sqlCols} FROM Users;';
  final ResultSet results = db.select(sql);
  return [for (final Row row in results) User.fromRow(row)];
}

User getUser(int id) {
  const sql = 'SELECT ${User.sqlCols} FROM Users WHERE ROWID = ?;';
  final ResultSet results = db.select(sql, [id]);
  final Row row = results[0];
  return User.fromRow(row);
}

int registerUser({
  required name,
  required currencyPrecision,
  required currency,
}) {
  const sql =
      'INSERT INTO Users(${User.sqlCols}) VALUES (${User.sqlColsQuestions});';
  db.execute(sql, [null, name, currencyPrecision, currency, null]);
  return db.lastInsertRowId;
}
