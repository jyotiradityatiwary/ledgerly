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

  List<TransactionCategory> _categories = [];
  UnmodifiableListView<TransactionCategory> get categories =>
      UnmodifiableListView(_categories);

  final User _user;

  AccountNotifier({required User user}) : _user = user {
    _loadAllAndNotify();
  }

  Future<void> _loadAllAndNotify() async {
    try {
      await Future.wait([
        _fetchAccounts(),
        _fetchTransactions(),
        _fetchCategories(),
      ]);
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

  Future<void> _fetchCategories() async {
    _categories = transactionCategoryCrudService.getAllFor(userId: _user.id);
  }

  Future<void> _notifyLoad() async {
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _notifyUnLoad() async {
    _isLoaded = false;
    notifyListeners();
  }

  Future<void> addOrModifyAccount({
    final int? originalId,
    required final String name,
    required final User user,
    required final int initialBalance,
    final String? description,
  }) async {
    await _notifyUnLoad();
    try {
      if (originalId == null) {
        final int newId = accountCrudService.create(
          name: name,
          user: user,
          initialBalance: initialBalance,
          description: description,
        );
        _accounts.add(accountCrudService.getById(newId));
      } else {
        // TODO: test
        accountCrudService.modify(
          originalId: originalId,
          name: name,
          user: user,
          initialBalance: initialBalance,
          description: description,
        );

        // update state
        final idx = _accounts.indexWhere(
          (element) => element.id == originalId,
        );
        _accounts[idx] = accountCrudService.getById(originalId);
      }
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
    TransactionCategory? category,
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
          category: category);
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

  Future<void> addOrModifyCategory({
    final int? originalId,
    required final String name,
    required final User user,
    required final TransactionType type,
    required final String? description,
  }) async {
    await _notifyUnLoad();
    try {
      if (originalId == null) {
        final int newId =
            transactionCategoryCrudService.insert(TransactionCategory(
          id: -1,
          user: user,
          name: name,
          type: type,
          description: description,
        ));
        _categories.add(transactionCategoryCrudService.getById(newId));
      } else {
        // TODO: test
        transactionCategoryCrudService.update(TransactionCategory(
          id: originalId,
          user: user,
          name: name,
          type: type,
          description: description,
        ));

        // update state
        final idx = _categories.indexWhere(
          (element) => element.id == originalId,
        );
        _categories[idx] = transactionCategoryCrudService.getById(originalId);
      }
    } finally {
      await _notifyLoad();
    }
  }

  bool areAnyTransactionsLinkedToCategory({required final int categoryId}) =>
      transactionCrudService.isCategoryUsed(categoryId: categoryId);

  Future<void> deleteCategory({required final int categoryId}) async {
    await _notifyUnLoad();
    try {
      final shouldRefreshTransactions =
          areAnyTransactionsLinkedToCategory(categoryId: categoryId);
      transactionCategoryCrudService.delete(categoryId);
      _categories.removeWhere(
        (category) => category.id == categoryId,
      );
      // re-fetch transactions if some have their category field changed
      if (shouldRefreshTransactions) await _fetchTransactions();
    } finally {
      await _notifyLoad();
    }
  }
}
