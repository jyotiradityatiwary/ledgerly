import 'dart:collection';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:ledgerly/model/data_classes.dart';
import 'package:ledgerly/services/crud_services.dart';

class UserNotifier with ChangeNotifier {
  List<User> _users = [];
  UnmodifiableListView<User> get users => UnmodifiableListView(_users);

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  UserNotifier() {
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

  static const int defaultCurrencyPrecision = 4;
  Future<void> createOrModifyUser({
    final int? originalUserId,
    required final String name,
    required final String currency,
  }) async {
    await _unLoad();

    try {
      if (originalUserId == null) {
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
      } else {
        userCrudService.update(User(
          id: originalUserId,
          name: name,
          currencyPrecision: defaultCurrencyPrecision,
          currency: currency,
        ));
        _users.map(
          (final User user) => user.id == originalUserId
              ? userCrudService.getById(originalUserId)
              : user,
        );
      }
    } finally {
      await _load();
    }
  }

  Future<void> deleteUser(final int userId) async {
    await _unLoad();
    userCrudService.delete(userId);
    await _load();
  }
}
