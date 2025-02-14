// import 'dart:collection';

// import 'package:flutter/material.dart';
// import 'dart:developer' as developer;

// class AccountsNotifier with ChangeNotifier {
//   List<Account> _accounts = [];
//   UnmodifiableListView<account_service.Account> get accounts =>
//       UnmodifiableListView(_accounts);

//   bool _isLoaded = false;
//   bool get isLoaded => _isLoaded;

//   AccountsNotifier() {
//     _load();
//   }

//   Future<void> _load() async {
//     _accounts = account_service.getAllAccounts();
//     _isLoaded = true;
//     notifyListeners();
//   }

//   Future<void> _unLoad() async {
//     _isLoaded = false;
//     notifyListeners();
//   }

//   Future<void> addAccount({
//     required final String name,
//     required final String currency,
//   }) async {
//     const defaultCurrencyPrecision = 4;

//     await _unLoad();

//     final userId = user_service.registerUser(
//       name: name,
//       currencyPrecision: defaultCurrencyPrecision,
//       currency: currency,
//     );
//     developer.log(
//       'Registered new user (id = $userId) with name=$name, '
//       'currencyPrecision=$defaultCurrencyPrecision,'
//       ' currency=$currency',
//     );

//     await _load();
//   }

//   Future<void> deleteUser(final int userId) async {
//     await _unLoad();
//     user_service.deleteUser(id: userId);
//     await _load();
//   }
// }
