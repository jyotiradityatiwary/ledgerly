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

  final User _user;

  AccountNotifier({required User user}) : _user = user {
    _loadAllAndNotify();
  }

  Future<void> _loadAllAndNotify() async {
    try {
      await _fetchAccounts();
      await _fetchTransactions();
    } finally {
      await _notifyLoad();
    }
  }

  Future<void> _fetchAccounts() async {
    _accounts = accountCrudService.getAllFor(userId: _user.id);
  }

  Future<void> _fetchTransactions() async {
    _transactions = transactionCrudService.getAllFor(userId: _user.id);
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

  Future<bool> hasTransactions(int accountId) async {
    return accountCrudService.hasTransactions(accountId: accountId);
  }

  Future<void> deleteAccount({required final int id}) async {
    await _notifyUnLoad();
    try {
      accountCrudService.delete(id);
      _accounts.removeWhere((account) => account.id == id);
    } finally {
      await _notifyLoad();
    }
  }

  Future<void> deleteAccountWithAssociatedTransactions({
    required final int accountId,
  }) async {
    await _notifyUnLoad();
    try {
      accountCrudService.delete(accountId);
      await _fetchTransactions();
      _accounts.removeWhere((final Account account) => account.id == accountId);
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
      await _fetchAccounts();
    } finally {
      await _notifyLoad();
    }
  }

  Future<void> undoTransaction({
    required final int transactionId,
  }) async {
    await _notifyUnLoad();
    try {
      transactionCrudService.delete(transactionId);
      _transactions.removeWhere((item) => item.id == transactionId);

      // reload accounts because balances will be changed
      await _fetchAccounts();
    } finally {
      await _notifyLoad();
    }
  }
}
