import 'package:ledgerly/model/crud_services/crud_service.dart';
import 'package:ledgerly/model/data_classes.dart';
import 'package:ledgerly/model/table_schema.dart';
import 'package:ledgerly/services/database_manager.dart';

class TransactionCrudService extends CrudService<Transaction> {
  final AccountSchema accountSchema;
  TransactionCrudService(super.schema, {required this.accountSchema});

  @override
  int insert(Transaction item) {
    throw UnimplementedError(
        "Do not insert into the transaction database directly. Use the `create` function which appropriately handles side effects.");
  }

  @override
  void delete(int id) {
    throw UnimplementedError(
        "Do not delete from the transaction database directly. Use the `undo` function which appropriately handles side effects.");
  }

  int create({
    required Account? sourceAccount,
    required Account? destinationAccount,
    required int amount,
    required String summary,
    String? description,
    required DateTime dateTime,
  }) {
    dbHandle.execute('BEGIN;');

    try {
      dbHandle.execute('''
      UPDATE ${accountSchema.tableName}
      SET ${accountSchema.updateBalanceSubtractClause}
      WHERE ${accountSchema.primaryKeyColumn} = ?;
''', [
        amount,
        sourceAccount?.id,
      ]);

      dbHandle.execute('''
      UPDATE ${accountSchema.tableName}
      SET ${accountSchema.updateBalanceAddClause}
      WHERE ${accountSchema.primaryKeyColumn} = ?;
''', [
        amount,
        destinationAccount?.id,
      ]);

      dbHandle.execute(
          '''
      INSERT INTO ${schema.tableName} (${schema.columns})
      VALUES (${schema.insertPlaceholders})
''',
          <Object?>[null] +
              schema.itemToListWithoutId(Transaction(
                id: -1,
                sourceAccount: sourceAccount,
                destinationAccount: destinationAccount,
                amount: amount,
                summary: summary,
                description: description,
                dateTime: dateTime,
              )));
      final int newId = dbHandle.lastInsertRowId;

      dbHandle.execute('COMMIT;');
      return newId;
    } catch (e) {
      dbHandle.execute('ROLLBACK;');
      rethrow;
    }
  }

  void undo(Transaction transaction) {
    dbHandle.execute('BEGIN;');

    try {
      dbHandle.execute('''
      UPDATE ${accountSchema.tableName}
      SET ${accountSchema.updateBalanceSubtractClause}
      WHERE ${accountSchema.primaryKeyColumn} = ?;
''', [
        transaction.amount,
        transaction.destinationAccount?.id,
      ]);

      dbHandle.execute('''
      UPDATE ${accountSchema.tableName}
      SET ${accountSchema.updateBalanceAddClause}
      WHERE ${accountSchema.primaryKeyColumn} = ?;
''', [
        transaction.amount,
        transaction.sourceAccount?.id,
      ]);

      dbHandle.execute('''
      DELETE FROM ${schema.tableName}
      WHERE ${schema.primaryKeyColumn} = ?;
''', [
        transaction.id,
      ]);

      dbHandle.execute('COMMIT;');
    } catch (e) {
      dbHandle.execute('ROLLBACK;');
      rethrow;
    }
  }
}
