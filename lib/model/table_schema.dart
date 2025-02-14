import 'package:sqlite3/sqlite3.dart';

class TableSchema<T> {
  /// Name of the table in sqlite3 databse
  final String tableName;

  /// Names of the columns (including primary key column) seperated by commas
  final String columns;

  /// Question marks instead of column names for each column
  final String insertPlaceholders;

  /// For each column, of the format `<Column Name> = ?`
  final String updateSetClauseWithoutId;

  /// Name of the column which corresponds to the primary key
  final String primaryKeyColumn;

  /// Query to be run to create this table
  final String createTableSql;

  /// Function that constructs item [T] given a [Row] from a [ResultSet]
  final T Function(Row row) rowToItem;

  /// Function that converts an item [T] to a list of it's properties (except for the ID)
  final List<Object?> Function(T item) itemToListWithoutId;

  const TableSchema({
    required this.tableName,
    required this.columns,
    required this.insertPlaceholders,
    required this.updateSetClauseWithoutId,
    required this.primaryKeyColumn,
    required this.createTableSql,
    required this.rowToItem,
    required this.itemToListWithoutId,
  });
}
