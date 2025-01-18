import 'package:flutter/material.dart';
import 'package:ledgerly/services/preferences_service.dart';

class LoginCheckerViewModel extends ChangeNotifier {
  bool get isLoggedIn => Preferences.isSomeOneLoggedIn.value;
  bool get currentUserId => Preferences.currentUserId.value;

  void login(int userId) {
    Preferences.currentUserId.value = userId;
    Preferences.isSomeOneLoggedIn.value = true;
    notifyListeners();
  }

  void logout() {
    Preferences.isSomeOneLoggedIn.value = false;
    notifyListeners();
  }
}
