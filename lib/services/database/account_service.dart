import 'user_service.dart';

class Account {
  final int id;
  final User user;
  final int initialBalance;
  final int currentBalance;
  final String? description;
  const Account({
    required this.id,
    required this.user,
    required this.initialBalance,
    required this.currentBalance,
    this.description,
  });
  static const String createTableSql = '''
CREATE TABLE Accounts (
  account_id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES Users(user_id),
  initial_balance INTEGER NOT NULL,
  current_balance INTEGER NOT NULL, -- derived
  account_description TEXT DEFAULT NULL
);
''';
}
