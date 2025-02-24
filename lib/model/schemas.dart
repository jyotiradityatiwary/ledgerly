import 'package:ledgerly/services/crud_services.dart';
import 'package:sqlite3/sqlite3.dart';

import 'data_classes.dart';
import 'table_schema.dart';

const accountSchema = AccountSchema(
  tableName: 'Accounts',
  columns:
      'account_id, name, user_id, initial_balance, current_balance, account_description',
  insertPlaceholders: '?, ?, ?, ?, ?, ?',
  updateSetClauseWithoutId:
      'name = ?, initial_balance = ?, current_balance = ?, account_description = ?',
  primaryKeyColumn: 'account_id',
  createTableSql: '''
CREATE TABLE Accounts (
  account_id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  user_id INTEGER NOT NULL REFERENCES Users(user_id),
  initial_balance INTEGER NOT NULL,
  current_balance INTEGER NOT NULL, -- derived
  account_description TEXT DEFAULT NULL
);
''',
  rowToItem: _rowToAccount,
  itemToListWithoutId: _accountToListWithoutId,
  updateBalanceAddClause: 'current_balance = current_balance + ?',
  updateBalanceSubtractClause: 'current_balance = current_balance - ?',
);

Account _rowToAccount(final Row row) => Account(
      id: row.columnAt(0),
      name: row.columnAt(1),
      user: userCrudService.getById(row.columnAt(2)),
      initialBalance: row.columnAt(3),
      currentBalance: row.columnAt(4),
      description: row.columnAt(5),
    );

List<Object?> _accountToListWithoutId(final Account account) => [
      account.name,
      account.user.id,
      account.initialBalance,
      account.currentBalance,
      account.description,
    ];

const budgetSchema = TableSchema<Budget>(
    tableName: 'Budgers',
    columns:
        'budget_id, user_id, category_id, budget_amount, start_date_time, end_date_time, recurrency_days, budget_name, budget_description',
    insertPlaceholders: '?, ?, ?, ?, ?, ?, ?, ?, ?',
    updateSetClauseWithoutId:
        'user_id = ?, category_id = ?, budget_amount = ?, start_date_time = ?, end_date_time = ?, recurrency_days = ?, budget_name = ?, budget_description = ?',
    primaryKeyColumn: 'budget_id',
    createTableSql: '''
CREATE TABLE Budgets (
    budget_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES Users(user_id),
    category_id INTEGER NOT NULL REFERENCES TransactionCategories(category_id),
    budget_amount INTEGER NOT NULL,
    start_date_time INTEGER NOT NULL,
    end_date_time INTEGER DEFAULT NULL,
    recurrency_days INTEGER NOT NULL,
    budget_name TEXT NOT NULL,
    budget_description TEXT DEFAULT NULL
);
''',
    rowToItem: _rowToBudget,
    itemToListWithoutId: _budgetToListWithoutId);

Budget _rowToBudget(final Row row) => Budget(
      id: row.columnAt(0),
      user: userCrudService.getById(row.columnAt(1)),
      category: transactionCategoryCrudService.getById(row.columnAt(2)),
      amount: row.columnAt(3),
      start: DateTime.fromMillisecondsSinceEpoch(row.columnAt(4)),
      end: DateTime.fromMillisecondsSinceEpoch(row.columnAt(5)),
      recurrence: Duration(days: row.columnAt(6)),
      name: row.columnAt(7),
      description: row.columnAt(8),
    );

List<Object?> _budgetToListWithoutId(final Budget budget) => [
      budget.user.id,
      budget.category.id,
      budget.amount,
      budget.start.millisecondsSinceEpoch,
      budget.end?.millisecondsSinceEpoch,
      budget.recurrence.inDays,
      budget.name,
      budget.description,
    ];

const cloudUserSchema = TableSchema<CloudUser>(
  tableName: 'CloudUsers',
  columns:
      'cloud_user_id, server_address, identifier, last_sync_date_time, login_expiry_date_time',
  insertPlaceholders: '?, ?, ?, ?, ?',
  updateSetClauseWithoutId:
      'server_address = ?, identifier = ?, last_sync_date_time = ?, login_expiry_date_time = ?',
  primaryKeyColumn: 'cloud_user_id',
  createTableSql: '''
CREATE TABLE CloudUsers (
  cloud_user_id INTEGER PRIMARY KEY,
  server_address TEXT NOT NULL,
  identifier TEXT NOT NULL,
  last_sync_date_time INTEGER NOT NULL,
  login_expiry_date_time INTEGER NOT NULL
);
''',
  rowToItem: _rowToCloudUser,
  itemToListWithoutId: _cloudUserToListWithoutId,
);

CloudUser _rowToCloudUser(final Row row) => CloudUser(
      id: row.columnAt(0),
      serverAddress: row.columnAt(1),
      identifier: row.columnAt(2),
      lastSyncDateTime: DateTime.fromMillisecondsSinceEpoch(row.columnAt(3)),
      loginExpiryDateTime: DateTime.fromMillisecondsSinceEpoch(row.columnAt(4)),
    );

List<Object?> _cloudUserToListWithoutId(final CloudUser cloudUser) => [
      cloudUser.serverAddress,
      cloudUser.identifier,
      cloudUser.lastSyncDateTime.millisecondsSinceEpoch,
      cloudUser.loginExpiryDateTime.millisecondsSinceEpoch,
    ];

const transactionCategorySchema = TableSchema<TransactionCategory>(
  tableName: 'TransactionCategories',
  columns:
      'category_id, user_id, category_name, category_type, category_description',
  insertPlaceholders: '?, ?, ?, ?, ?',
  updateSetClauseWithoutId:
      'user_id = ?, category_name = ?, category_type = ?, category_description = ?',
  primaryKeyColumn: 'category_id',
  createTableSql: '''
CREATE TABLE TransactionCategories (
  category_id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES Users(user_id),
  category_name TEXT NOT NULL,
  category_type INTEGER NOT NULL,
  category_description TEXT DEFAULT NULL
);
''',
  rowToItem: _rowToTransactionCategory,
  itemToListWithoutId: _transactionCategoryToListWithoutId,
);

TransactionCategory _rowToTransactionCategory(final Row row) =>
    TransactionCategory(
      id: row.columnAt(0),
      user: userCrudService.getById(row.columnAt(1)),
      name: row.columnAt(2),
      type: TransactionType.values[row.columnAt(3)],
      description: row.columnAt(4),
    );

List<Object?> _transactionCategoryToListWithoutId(
  final TransactionCategory category,
) =>
    [
      category.user.id,
      category.name,
      category.type.index,
      category.description,
    ];

const transactionSchema = TransactionSchema(
  tableName: 'Transactions',
  columns:
      'transaction_id, source_account_id, destination_account_id, amount, transaction_summary, transaction_description, transaction_datetime',
  insertPlaceholders: '?, ?, ?, ?, ?, ?, ?',
  updateSetClauseWithoutId:
      'transaction_id = ?, source_account_id = ?, destination_account_id = ?, amount= ?, transaction_summary = ?, transaction_description = ?, transaction_datetime = ?',
  primaryKeyColumn: 'transaction_id',
  createTableSql: '''
CREATE TABLE Transactions (
    transaction_id INTEGER PRIMARY KEY,
    source_account_id INTEGER DEFAULT NULL REFERENCES Accounts(account_id),
    destination_account_id INTEGER DEFAULT NULL REFERENCES Accounts(account_id),
    amount INTEGER NOT NULL,
    transaction_summary TEXT NOT NULL,
    transaction_description TEXT DEFAULT NULL,
    transaction_datetime INTEGER NOT NULL
);
''',
  rowToItem: _rowToTransaction,
  itemToListWithoutId: _transactionToListWithoutId,
  sourceAccountIdColumn: 'source_account_id',
  destinationAccountIdColumn: 'destination_account_id',
);

Transaction _rowToTransaction(final Row row) => Transaction(
      id: row.columnAt(0),
      sourceAccount: row.columnAt(1) == null
          ? null
          : accountCrudService.getById(row.columnAt(1)),
      destinationAccount: row.columnAt(2) == null
          ? null
          : accountCrudService.getById(row.columnAt(2)),
      amount: row.columnAt(3),
      summary: row.columnAt(4),
      description: row.columnAt(5),
      dateTime: DateTime.fromMillisecondsSinceEpoch(row.columnAt(6)),
    );

List<Object?> _transactionToListWithoutId(final Transaction transaction) => [
      transaction.sourceAccount?.id,
      transaction.destinationAccount?.id,
      transaction.amount,
      transaction.summary,
      transaction.description,
      transaction.dateTime.millisecondsSinceEpoch,
    ];

const userSchema = TableSchema<User>(
  tableName: 'Users',
  columns: 'user_id, user_name, currency_precision, currency, cloud_user_id',
  insertPlaceholders: '?, ?, ?, ?, ?',
  updateSetClauseWithoutId:
      'user_name = ?, currency_precision = ?, currency = ?, cloud_user_id = ?',
  primaryKeyColumn: 'user_id',
  createTableSql: '''CREATE TABLE Users (
  user_id INTEGER PRIMARY KEY,
  user_name TEXT NOT NULL,
  currency_precision INT NOT NULL,
  currency TEXT NOT NULL,
  cloud_user_id INTEGER DEFAULT NULL UNIQUE REFERENCES CloudUsers(cloud_user_id)
);''',
  rowToItem: _rowToUser,
  itemToListWithoutId: _userToListWithoutId,
);

User _rowToUser(final Row row) => User(
      id: row.columnAt(0),
      name: row.columnAt(1),
      currencyPrecision: row.columnAt(2),
      currency: row.columnAt(3),
      cloudUser: row.columnAt(4),
    );

List<Object?> _userToListWithoutId(final User user) => [
      user.name,
      user.currencyPrecision,
      user.currency,
      user.cloudUser?.id,
    ];
