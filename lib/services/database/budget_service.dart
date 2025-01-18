import 'transaction_category_service.dart';
import 'user_service.dart';

class Budget {
  final int id;
  final User user;
  final TransactionCategory category;
  final int amount;
  final DateTime start;
  final DateTime? end;
  final Duration recurrence;
  final String name;
  final String? description;

  const Budget({
    required this.id,
    required this.user,
    required this.category,
    required this.amount,
    required this.start,
    this.end,
    required this.recurrence,
    required this.name,
    this.description,
  });

  static const createTableSql = '''
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
}
