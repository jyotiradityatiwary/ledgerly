import 'package:ledgerly/model/data_classes.dart';
import 'package:ledgerly/services/database_manager.dart';
import 'package:sqlite3/sqlite3.dart';
import '../table_schema.dart';

class CrudService<T extends DatabaseObject> {
  final TableSchema<T> schema;
  const CrudService(this.schema);

  List<T> getAll() {
    final sql = 'SELECT ${schema.columns} FROM ${schema.tableName};';
    final results = dbHandle.select(sql);
    return results.map(schema.rowToItem).toList();
  }

  List<int> getAllIds() {
    final sql = 'SELECT ${schema.primaryKeyColumn} FROM ${schema.tableName};';
    final results = dbHandle.select(sql);
    return results.map((final Row row) => row.columnAt(0) as int).toList();
  }

  T getById(int id) {
    final sql = '''
      SELECT ${schema.columns}
      FROM ${schema.tableName}
      WHERE ${schema.primaryKeyColumn} = ?;
    ''';
    final results = dbHandle.select(sql, [id]);
    return schema.rowToItem(results.first);
  }

  bool containsId(final int id) {
    final sql = '''
      SELECT ${schema.primaryKeyColumn}
      FROM ${schema.tableName}
      WHERE ${schema.primaryKeyColumn} = ?;
    ''';
    final results = dbHandle.select(sql, [id]);
    assert(results.isEmpty || results.length == 1);
    return results.isNotEmpty;
  }

  T? getByIdIfExists(final int id) {
    final sql = '''
      SELECT ${schema.columns}
      FROM ${schema.tableName}
      WHERE ${schema.primaryKeyColumn} = ?;
    ''';
    final results = dbHandle.select(sql, [id]);
    assert(results.isEmpty || results.length == 1);
    return results.isEmpty ? null : schema.rowToItem(results.first);
  }

  int insert(T item) {
    final sql = '''
      INSERT INTO ${schema.tableName} (${schema.columns})
      VALUES (${schema.insertPlaceholders});
    ''';
    // we will send a null in place of ID for sqlite3 to auto generate ID
    dbHandle.execute(sql, <Object?>[null] + schema.itemToListWithoutId(item));
    return dbHandle.lastInsertRowId;
  }

  void update(T item) {
    final sql = '''
      UPDATE ${schema.tableName}
      SET ${schema.updateSetClauseWithoutId}
      WHERE ${schema.primaryKeyColumn} = ?;
    ''';
    dbHandle.execute(sql, schema.itemToListWithoutId(item) + [item.id]);
  }

  void delete(final int id) {
    final sql = '''
      DELETE FROM ${schema.tableName}
      WHERE ${schema.primaryKeyColumn} = ?;
    ''';
    dbHandle.execute(sql, [id]);
  }
}

class UserOwnedCrudService<T extends DatabaseObject> extends CrudService<T> {
  final UserOwnedTableSchema<T> userOwnedSchema;

  UserOwnedCrudService(this.userOwnedSchema) : super(userOwnedSchema);

  List<T> getAllFor({required final int userId}) {
    final String sql = '''
      SELECT ${schema.columns}
      FROM ${schema.tableName}
      WHERE ${userOwnedSchema.userIdForeignKeyColumn} = ?;
    ''';
    final List<Object?> args = [userId];
    final results = dbHandle.select(sql, args);
    return results.map(schema.rowToItem).toList();
  }
}
