import 'package:flutter/material.dart';
import 'package:ledgerly/model/data_classes.dart';
import 'package:ledgerly/services/crud_services.dart';
import 'package:ledgerly/services/preference_service.dart';

class PreferencesNotifier extends ChangeNotifier {
  bool _isLoaded = false;
  get isLoaded => _isLoaded;

  User? _user;
  User? get user => _user;

  PreferencesNotifier() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _user = Preferences.isSomeOneLoggedIn.value &&
            userCrudService.containsId(Preferences.currentUserId.value)
        ? userCrudService.getById(Preferences.currentUserId.value)
        : null;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _unLoad() async {
    _isLoaded = false;
    notifyListeners();
  }

  Future<void> login({required final int userId}) async {
    await _unLoad();

    Preferences.isSomeOneLoggedIn.value = true;
    Preferences.currentUserId.value = userId;

    await _loadUser();
  }

  Future<void> logout() async {
    await _unLoad();

    Preferences.isSomeOneLoggedIn.value = false;
    Preferences.currentUserId.value = -1;

    await _loadUser();
  }
}
