import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ledgerly/services/database/user_service.dart' as user_service;
import 'dart:developer' as developer;

class LoginScreenViewModel with ChangeNotifier {
  List<user_service.User> _users = [];
  UnmodifiableListView<user_service.User> get users =>
      UnmodifiableListView(_users);

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  LoginScreenViewModel() {
    _load();
  }

  Future<void> _load() async {
    _users = user_service.getAllUsers();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _unLoad() async {
    _isLoaded = false;
    notifyListeners();
  }

  Future<void> addUser({
    required final String name,
    required final String currency,
  }) async {
    const defaultCurrencyPrecision = 4;

    await _unLoad();

    final userId = user_service.registerUser(
      name: name,
      currencyPrecision: defaultCurrencyPrecision,
      currency: currency,
    );
    developer.log(
      'Registered new user (id = $userId) with name=$name, '
      'currencyPrecision=$defaultCurrencyPrecision,'
      ' currency=$currency',
    );

    await _load();
  }

  Future<void> deleteUser(final int userId) async {
    await _unLoad();
    user_service.deleteUser(id: userId);
    await _load();
  }
}
