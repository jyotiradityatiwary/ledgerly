import 'package:ledgerly/services/database/cloud_user_service.dart';
import 'package:ledgerly/services/database_manager.dart';
import 'package:sqlite3/sqlite3.dart';

class User {
  final int id;
  final String name;
  final int currencyPrecision;
  final String currency;
  final CloudUser? cloudUser;

  const User({
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

  static const createTableSql = '''
CREATE TABLE $sqlTable (
  user_id INTEGER PRIMARY KEY,
  user_name TEXT NOT NULL,
  currency_precision INT NOT NULL,
  currency TEXT NOT NULL,
  cloud_user_id INTEGER DEFAULT NULL UNIQUE REFERENCES CloudUsers(cloud_user_id)
);''';
  static const sqlCols =
      'user_id, user_name, currency_precision, currency, cloud_user_id';
  static const sqlColsQuestions = '?, ?, ?, ?, ?';
  static const sqlUpdateClauseWithoutId =
      'user_name = ?, currency_precision = ?, currency = ?, cloud_user_id = ?';
  static const sqlTable = 'Users';

  List<Object?> toListWithoutId() =>
      [name, currencyPrecision, currency, cloudUser?.id];

  @override
  int get hashCode => id;
  @override
  bool operator ==(final Object other) => other is User && id == other.id;
}

List<int> getAllUserIds() {
  const String sql = 'SELECT ROWID FROM ${User.sqlTable};';
  final ResultSet results = db.select(sql);
  return [for (Row row in results) row.columnAt(0) as int];
}

List<User> getAllUsers() {
  const String sql = 'SELECT ${User.sqlCols} FROM ${User.sqlTable};';
  final ResultSet results = db.select(sql);
  return [for (final Row row in results) User.fromRow(row)];
}

User getUser(int id) {
  const sql = 'SELECT ${User.sqlCols} FROM ${User.sqlTable} WHERE ROWID = ?;';
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
      'INSERT INTO ${User.sqlTable}(${User.sqlCols}) VALUES (${User.sqlColsQuestions});';
  db.execute(sql, [null, name, currencyPrecision, currency, null]);
  return db.lastInsertRowId;
}

void deleteUser({required int id}) {
  const sql = "DELETE FROM ${User.sqlTable} WHERE ROWID = ? RETURNING ROWID;";
  final ResultSet results = db.select(sql, [id]);
  assert(results.length == 1);
}

void updateUser(User user) {
  const sql =
      "UPDATE ${User.sqlTable} SET ${User.sqlUpdateClauseWithoutId} WHERE ROWID = ? RETURNING ROWID;";
  final ResultSet results = db.select(sql, [user.toListWithoutId()]);
  assert(results.length == 1);
}
