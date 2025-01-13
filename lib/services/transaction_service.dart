import 'package:ledgerly/services/accounts_service.dart';

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
  static const String createTableSql = '''
CREATE TABLE Transactions (
    transaction_id INTEGER PRIMARY KEY,
    source_account_id INTEGER NOT NULL REFERENCES Accounts(account_id),
    destination_account_id INTEGER NOT NULL REFERENCES Accounts(account_id),
    amount INTEGER NOT NULL,
    transaction_summary TEXT NOT NULL,
    transaction_description TEXT DEFAULT NULL,
    transaction_datetime INTEGER NOT NULL
);
''';
}
