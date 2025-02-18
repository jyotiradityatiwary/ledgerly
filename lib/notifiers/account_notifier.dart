import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:ledgerly/model/data_classes.dart';
import 'package:ledgerly/services/crud_services.dart';

class AccountNotifier with ChangeNotifier {
  List<Account> _accounts = [];
  UnmodifiableListView<Account> get accounts => UnmodifiableListView(_accounts);

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  List<Transaction> _transactions = [];
  UnmodifiableListView<Transaction> get transactions =>
      UnmodifiableListView(_transactions);

  AccountNotifier() {
    _loadAllAndNotify();
  }

  Future<void> _loadAllAndNotify() async {
    await _partialLoadAccounts();
    await _partialLoadTransactions();
    await _notifyLoad();
  }

  Future<void> _partialLoadAccounts() async {
    _accounts = accountCrudService.getAll();
  }

  Future<void> _partialLoadTransactions() async {
    _transactions = transactionCrudService.getAll();
    await _notifyLoad();
  }

  Future<void> _notifyLoad() async {
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _notifyUnLoad() async {
    _isLoaded = false;
    notifyListeners();
  }

  Future<void> addAccount({
    required final String name,
    required final User user,
    required final int initialBalance,
    final String? description,
  }) async {
    await _notifyUnLoad();
    try {
      final int newId = accountCrudService.create(
        name: name,
        user: user,
        initialBalance: initialBalance,
        description: description,
      );
      _accounts.add(accountCrudService.getById(newId));
    } finally {
      await _notifyLoad();
    }
  }

  // TODO: ensure that this account has no transactions. otherwise offer user an option to cascade and undo those transactions first
  Future<void> deleteAccount({required final int id}) async {
    await _notifyUnLoad();
    try {
      accountCrudService.delete(id);
      _accounts.removeWhere((account) => account.id == id);
    } finally {
      await _notifyLoad();
    }
  }

  Future<void> createTransaction({
    required Account? sourceAccount,
    required Account? destinationAccount,
    required int amount,
    required String summary,
    String? description,
    required DateTime dateTime,
  }) async {
    await _notifyUnLoad();
    try {
      final int newId = transactionCrudService.create(
        sourceAccount: sourceAccount,
        destinationAccount: destinationAccount,
        amount: amount,
        summary: summary,
        description: description,
        dateTime: dateTime,
      );
      _transactions.add(transactionCrudService.getById(newId));

      // reload accounts because balances will be changed
      await _partialLoadAccounts();
    } finally {
      await _notifyLoad();
    }
  }

  Future<void> undoTransaction({
    required final Transaction transaction,
  }) async {
    await _notifyUnLoad();
    try {
      transactionCrudService.undo(transaction);
      _transactions.removeWhere((item) => item.id == transaction.id);

      // reload accounts because balances will be changed
      await _partialLoadAccounts();
    } finally {
      await _notifyLoad();
    }
  }
}
