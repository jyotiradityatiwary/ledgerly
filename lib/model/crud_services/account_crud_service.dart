import 'package:ledgerly/model/crud_services/crud_service.dart';
import 'package:ledgerly/model/data_classes.dart';
import 'package:ledgerly/model/table_schema.dart';
import 'package:ledgerly/services/database_manager.dart';

class AccountCrudService extends CrudService<Account> {
  final TransactionSchema transactionSchema;
  final AccountSchema accountSchema;

  AccountCrudService(
    this.accountSchema, {
    required this.transactionSchema,
  }) : super(accountSchema);

  List<Account> getAllFor({required final int userId}) {
    final String sql = '''
      SELECT ${accountSchema.columns}
      FROM ${accountSchema.tableName}
      WHERE ${accountSchema.userIdForeignKeyColumn} = ?;
    ''';
    final List<Object?> args = [userId];
    final results = dbHandle.select(sql, args);
    return results.map(schema.rowToItem).toList();
  }

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

  @override
  void update(Account item) {
    throw UnimplementedError('Do not update directly. Use the modify function');
  }

  void modify({
    required final int originalId,
    required final String name,
    required final User user,
    required final int initialBalance,
    required final String? description,
  }) {
    final String sql = '''
    UPDATE Accounts
    SET name = ?, user_id = ?, initial_balance = ?, account_description = ?
    WHERE account_id = ?;
    ''';
    final List<Object?> args = [
      name,
      user.id,
      initialBalance,
      description,
      originalId,
    ];
    dbHandle.execute(sql, args);
  }
}
