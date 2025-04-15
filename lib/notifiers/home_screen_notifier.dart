import 'package:flutter/widgets.dart';
import 'package:ledgerly/services/preference_service.dart';

class HomeScreenNotifier extends ChangeNotifier {
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  late int _navBarSelection;
  int get navBarSelection => _navBarSelection;

  HomeScreenNotifier() {
    _loadAllAndNotify();
  }

  Future<void> _loadAllAndNotify() async {
    _fetchNavBarSelection();
    _notifyLoaded(true);
  }

  void _notifyLoaded(final bool newState) {
    _isLoaded = newState;
    notifyListeners();
  }

  void _fetchNavBarSelection() {
    _navBarSelection = Preferences.homeScreenNavBarSelection.value;
  }

  Future<void> changeNavBarSelection(final int newSelection) async {
    _notifyLoaded(false);
    _navBarSelection = newSelection;
    // we can notify before saving changes before saving changes is not necessary here
    _notifyLoaded(true);
    Preferences.homeScreenNavBarSelection.value = newSelection;
  }
}
