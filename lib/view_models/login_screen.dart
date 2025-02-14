import 'dart:collection';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:ledgerly/model/data_classes.dart';
import 'package:ledgerly/services/crud_services.dart';

class LoginScreenViewModel with ChangeNotifier {
  List<User> _users = [];
  UnmodifiableListView<User> get users => UnmodifiableListView(_users);

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  LoginScreenViewModel() {
    _load();
  }

  Future<void> _load() async {
    _users = userCrudService.getAll();
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

    final userId = userCrudService.register(
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
    userCrudService.delete(userId);
    await _load();
  }
}
