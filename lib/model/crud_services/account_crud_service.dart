import 'package:ledgerly/model/crud_services/crud_service.dart';
import 'package:ledgerly/model/data_classes.dart';
import 'package:ledgerly/model/table_schema.dart';
import 'package:ledgerly/services/database_manager.dart';

class AccountCrudService extends CrudService<Account> {
  final TransactionSchema transactionSchema;

  AccountCrudService(
    super.schema, {
    required this.transactionSchema,
  });

  int create({
    required final String name,
    required final User user,
    required final int initialBalance,
    final String? description,
  }) =>
      insert(Account(
        id: -1,
        name: name,
        user: user,
        initialBalance: initialBalance,
        currentBalance: initialBalance,
        description: description,
      ));

  bool hasTransactions({required int accountId}) {
    final sql = '''
      SELECT EXISTS (
        SELECT 1
        FROM ${transactionSchema.tableName}
        WHERE ${transactionSchema.sourceAccountIdColumn} = ?
        OR ${transactionSchema.destinationAccountIdColumn} = ?
      );
    ''';
    final List<Object?> args = [accountId, accountId];
    final results = dbHandle.select(sql, args);
    final int count = results.first.columnAt(0);
    assert(count == 0 || count == 1);
    return count == 1;
  }

  void deleteTransactionsFor({required final int accountId}) {
    final String sql = '''
      DELETE FROM ${transactionSchema.tableName}
      WHERE ${transactionSchema.sourceAccountIdColumn} = ?
      OR ${transactionSchema.destinationAccountIdColumn} = ?;
    ''';
    final List<Object?> args = [accountId, accountId];
    dbHandle.execute(sql, args);
  }
}
