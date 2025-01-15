import 'package:ledgerly/services/database/accounts_service.dart';
import 'package:sqlite3/sqlite3.dart';

import '../database_manager.dart';

class Transaction {
  final int id;
  final Account sourceAccount;
  final Account destinationAccount;
  final int amount;
  final String summary;
  final String? description;
  final DateTime dateTime;
  const Transaction({
    required this.id,
    required this.sourceAccount,
    required this.destinationAccount,
    required this.amount,
    required this.summary,
    required this.description,
    required this.dateTime,
  });
  static Transaction fromRow(final Row row) => Transaction(
        id: row.columnAt(0),
        sourceAccount: row.columnAt(1),
        destinationAccount: row.columnAt(2),
        amount: row.columnAt(3),
        summary: row.columnAt(4),
        description: row.columnAt(5),
        dateTime: row.columnAt(6),
      );
  static const String createTableSql = '''
CREATE TABLE $sqlTable (
    transaction_id INTEGER PRIMARY KEY,
    source_account_id INTEGER NOT NULL REFERENCES Accounts(account_id),
    destination_account_id INTEGER NOT NULL REFERENCES Accounts(account_id),
    amount INTEGER NOT NULL,
    transaction_summary TEXT NOT NULL,
    transaction_description TEXT DEFAULT NULL,
    transaction_datetime INTEGER NOT NULL
);
''';
  static const sqlCols =
      'transaction_id, transaction_name, currency_precision, currency, cloud_transaction_id';
  static const sqlColsQuestions = '?, ?, ?, ?, ?';
  static const sqlTable = 'Transactions';
  static const sqlUpdateClauseWithoutId =
      'transaction_name=?, currency_precision=?, currency=?, cloud_transaction_id=?';

  List<Object?> toListWithoutId() => [
        sourceAccount,
        destinationAccount,
        amount,
        summary,
        description,
        dateTime
      ];

  @override
  int get hashCode => id;
  @override
  bool operator ==(final Object other) =>
      other is Transaction && id == other.id;
}

List<int> getAllTransactionIds() {
  const String sql = 'SELECT ROWID FROM ${Transaction.sqlTable};';
  final ResultSet results = db.select(sql);
  return [for (Row row in results) row.columnAt(0) as int];
}

List<Transaction> getAllTransactions() {
  const String sql =
      'SELECT ${Transaction.sqlCols} FROM ${Transaction.sqlTable};';
  final ResultSet results = db.select(sql);
  return [for (final Row row in results) Transaction.fromRow(row)];
}

Transaction getTransaction(int id) {
  const sql =
      'SELECT ${Transaction.sqlCols} FROM ${Transaction.sqlTable} WHERE ROWID = ?;';
  final ResultSet results = db.select(sql, [id]);
  final Row row = results[0];
  return Transaction.fromRow(row);
}

int registerTransaction({
  required name,
  required currencyPrecision,
  required currency,
}) {
  const sql =
      'INSERT INTO ${Transaction.sqlTable}(${Transaction.sqlCols}) VALUES (${Transaction.sqlColsQuestions});';
  db.execute(sql, [null, name, currencyPrecision, currency, null]);
  return db.lastInsertRowId;
}

void deleteUser({required int id}) {
  const sql =
      "DELETE FROM ${Transaction.sqlTable} WHERE ROWID = ? RETURNING ROWID;";
  final ResultSet results = db.select(sql, [id]);
  assert(results.length == 1);
}

void updateTransaction(Transaction user) {
  const sql =
      "UPDATE ${Transaction.sqlTable} SET ${Transaction.sqlUpdateClauseWithoutId} WHERE ROWID = ? RETURNING ROWID;";
  final ResultSet results = db.select(sql, [user.toListWithoutId()]);
  assert(results.length == 1);
}
