import 'package:flutter/material.dart';
import 'package:ledgerly/services/database/user_service.dart';

class UserPickerViewModel extends ChangeNotifier {
  List<User> _userList;
  List<User> get userList => _userList;

  UserPickerViewModel() : _userList = getAllUsers();

  void addUser({
    required name,
    required currencyPrecision,
    required currency,
  }) {
    registerUser(
      name: name,
      currencyPrecision: currencyPrecision,
      currency: currency,
    );
    _userList = getAllUsers();
  }
}
