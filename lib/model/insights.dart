import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ledgerly/services/database_manager.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

final _totalBalanceStmt =
    dbHandle.prepare("SELECT SUM(current_balance) FROM Accounts;");

int getTotalBalance() => _totalBalanceStmt.select().first.columnAt(0);

final _dailyExpenditureStmt = dbHandle.prepare('''
SELECT transaction_date, SUM(amount)
FROM (
  SELECT date(transaction_datetime / 1000, 'unixepoch') AS transaction_date, amount
  FROM Transactions
  WHERE destination_account_id IS NULL
)
GROUP BY transaction_date
ORDER BY transaction_date ASC;
''');

List<FlSpot> getDailyExpenditureData() => _dailyExpenditureStmt
    .select()
    .map((row) => FlSpot(
          _doubleFromDateString(row.columnAt(0)),
          (row.columnAt(1) as int).toDouble(),
        ))
    .toList();

double _doubleFromDateString(final String dateString) =>
    DateTime.parse(dateString).millisecondsSinceEpoch.toDouble();

final _monthlyExpenditureStmt = dbHandle.prepare('''
SELECT transaction_month, SUM(amount)
FROM (
  SELECT strftime('%Y-%m-01', transaction_datetime / 1000, 'unixepoch') AS transaction_month, amount
  FROM Transactions
  WHERE destination_account_id IS NULL
)
GROUP BY transaction_month
ORDER BY transaction_month ASC;
''');

List<FlSpot> getMonthlyExpenditureData() => _monthlyExpenditureStmt
    .select()
    .map((row) => FlSpot(
          _doubleFromDateString(row.columnAt(0)),
          (row.columnAt(1) as int).toDouble(),
        ))
    .toList();

final _monthlyIncomeStmt = dbHandle.prepare('''
SELECT transaction_month, SUM(amount)
FROM (
  SELECT strftime('%Y-%m-01', transaction_datetime / 1000, 'unixepoch') AS transaction_month, amount
  FROM Transactions
  WHERE source_account_id IS NULL
)
GROUP BY transaction_month
ORDER BY transaction_month ASC;
''');

List<FlSpot> getMonthlyIncomeData() => _monthlyIncomeStmt
    .select()
    .map((row) => FlSpot(
          _doubleFromDateString(row.columnAt(0)),
          (row.columnAt(1) as int).toDouble(),
        ))
    .toList();

final _expenditureByCategoryStmt = dbHandle.prepare('''
SELECT 
    tc.category_name, 
    SUM(t.amount)
FROM 
    Transactions t
INNER JOIN 
    TransactionCategories tc
    ON t.category_id = tc.category_id
WHERE 
    t.destination_account_id IS NULL
GROUP BY 
    t.category_id;
''');

List<AmountByCategoryDataItem> getExpenditureByCategoryData() =>
    _expenditureByCategoryStmt.select().indexed.map<AmountByCategoryDataItem>(
      (final (int, sqlite3.Row) pair) {
        final index = pair.$1;
        final row = pair.$2;
        final color = _sectionColors[index % _sectionColors.length];
        final int value = row.columnAt(1);
        return AmountByCategoryDataItem(
          section: PieChartSectionData(
            value: value.toDouble(),
            color: color,
            showTitle: false,
          ),
          name: (row.columnAt(0) as String),
        );
      },
    ).toList();

class AmountByCategoryDataItem {
  final PieChartSectionData section;
  final String name;

  const AmountByCategoryDataItem({
    required this.section,
    required this.name,
  });
}

const List<Color> _sectionColors = [
  Colors.amber,
  Colors.blue,
  Colors.deepOrange,
  Colors.deepPurple,
  Colors.yellow,
  Colors.teal,
  Colors.pink,
];
