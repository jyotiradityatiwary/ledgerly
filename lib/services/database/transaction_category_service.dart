import 'user_service.dart';

class TransactionCategory {
  final int id;
  final User user;
  final String name;
  final TransactionType type;
  final String? description;
  const TransactionCategory({
    required this.id,
    required this.user,
    required this.name,
    required this.type,
    this.description,
  });
  static const createTableSql = '''
CREATE TABLE TransactionCategories (
  category_id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES Users(user_id),
  category_name TEXT NOT NULL,
  category_type INTEGER NOT NULL,
  category_description TEXT DEFAULT NULL
);
''';
}

enum TransactionType {
  incoming,
  outgoing,
  internalTransfer,
}
