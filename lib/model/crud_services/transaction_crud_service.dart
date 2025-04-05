import 'package:ledgerly/model/crud_services/crud_service.dart';
import 'package:ledgerly/model/data_classes.dart';
import 'package:ledgerly/model/table_schema.dart';
import 'package:ledgerly/services/database_manager.dart';

class TransactionCrudService extends CrudService<Transaction> {
  final AccountSchema accountSchema;
  final TransactionSchema transactionSchema;
  TransactionCrudService(
    this.transactionSchema, {
    required this.accountSchema,
  }) : super(transactionSchema);

  List<Transaction> getAllFor({required int userId}) {
    /*
    SELECT t.*
    FROM Transactions t
    LEFT JOIN Accounts src_acc ON t.source_account_id = src_acc.account_id
    LEFT JOIN Accounts dest_acc ON t.destination_account_id = dest_acc.account_id
    WHERE src_acc.user_id = :user_id OR dest_acc.user_id = :user_id;
    */
    final RegExp pattern = RegExp(', *');
    final String columns =
        schema.columns.split(pattern).map((col) => 't.$col').join(', ');
    final sql = '''
      SELECT $columns
      FROM Transactions t
      LEFT JOIN Accounts src_acc
      ON t.${transactionSchema.sourceAccountIdColumn} = src_acc.${accountSchema.primaryKeyColumn}
      LEFT JOIN Accounts dest_acc
      ON t.${transactionSchema.destinationAccountIdColumn} = dest_acc.${accountSchema.primaryKeyColumn}
      WHERE src_acc.${accountSchema.userIdForeignKeyColumn} = ?
      OR dest_acc.${accountSchema.userIdForeignKeyColumn} = ?;
    ''';
    final List<Object?> args = [userId, userId];
    final results = dbHandle.select(sql, args);
    return results.map(schema.rowToItem).toList();
  }

  int create({
    required Account? sourceAccount,
    required Account? destinationAccount,
    required int amount,
    required String summary,
    String? description,
    required DateTime dateTime,
    TransactionCategory? category,
  }) =>
      insert(Transaction(
        id: -1,
        sourceAccount: sourceAccount,
        destinationAccount: destinationAccount,
        amount: amount,
        summary: summary,
        description: description,
        dateTime: dateTime,
        category: category,
      ));

  bool isCategoryUsed({required final int categoryId}) {
    final sql = '''
      SELECT EXISTS (
        SELECT 1
        FROM ${transactionSchema.tableName}
        WHERE ${transactionSchema.categoryIdColumn} = ?
      );
    ''';
    final List<Object?> args = [categoryId];
    final results = dbHandle.select(sql, args);
    final int count = results.first.columnAt(0);
    assert(count == 0 || count == 1);
    return count == 1;
  }
}
