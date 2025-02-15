import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:ledgerly/model/data_classes.dart';
import 'package:ledgerly/services/crud_services.dart';

class AccountNotifier with ChangeNotifier {
  List<Account> _accounts = [];
  UnmodifiableListView<Account> get accounts => UnmodifiableListView(_accounts);

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  AccountNotifier() {
    _load();
  }

  Future<void> _load() async {
    _accounts = accountCrudService.getAll();
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

  Future<void> deleteAccount({required final int id}) async {
    await _notifyUnLoad();
    try {
      accountCrudService.delete(id);
      _accounts.removeWhere((account) => account.id == id);
    } finally {
      await _notifyLoad();
    }
  }
}
