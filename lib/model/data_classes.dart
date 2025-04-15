import 'dart:math' as math;

abstract class DatabaseObject {
  int get id;

  @override
  bool operator ==(Object other) =>
      runtimeType == other.runtimeType && id == (other as DatabaseObject).id;

  @override
  int get hashCode => id;

  const DatabaseObject();
}

class Account extends DatabaseObject {
  @override
  final int id;
  final String name;
  final User user;
  final int initialBalance;
  final int currentBalance;
  final String? description;
  const Account({
    required this.id,
    required this.name,
    required this.user,
    required this.initialBalance,
    required this.currentBalance,
    required this.description,
  });
}

class Budget extends DatabaseObject {
  @override
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
    required this.end,
    required this.recurrence,
    required this.name,
    required this.description,
  });
}

class CloudUser extends DatabaseObject {
  @override
  final int id;
  final int userId;
  final String serverAddress;
  final String identifier;
  final DateTime lastSyncDateTime;
  final DateTime loginExpiryDateTime;

  const CloudUser({
    required this.id,
    required this.userId,
    required this.serverAddress,
    required this.identifier,
    required this.lastSyncDateTime,
    required this.loginExpiryDateTime,
  });
}

class TransactionCategory extends DatabaseObject {
  @override
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
    required this.description,
  });
}

enum TransactionType {
  incoming,
  outgoing,
  internalTransfer,
}

class Transaction extends DatabaseObject {
  @override
  final int id;
  final Account? sourceAccount;
  final Account? destinationAccount;
  final int amount;
  final String summary;
  final String? description;
  final DateTime dateTime;
  final TransactionCategory? category;
  const Transaction({
    required this.id,
    required this.sourceAccount,
    required this.destinationAccount,
    required this.amount,
    required this.summary,
    required this.description,
    required this.dateTime,
    required this.category,
  });
}

class User extends DatabaseObject {
  @override
  final int id;
  final String name;
  final int currencyPrecision;
  final String currency;

  const User({
    required this.id,
    required this.name,
    required this.currencyPrecision,
    required this.currency,
  });

  String formatIntMoney(
    final int magnitude, {
    final bool showCurrency = false,
  }) {
    final double displayValue = doubleFromIntMoney(magnitude);
    return showCurrency ? '$currency $displayValue' : displayValue.toString();
  }

  double doubleFromIntMoney(final int magnitude) =>
      magnitude.toDouble() / math.pow(10.0, currencyPrecision);
}
