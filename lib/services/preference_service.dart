import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferencesWithCache _sp;

Future<void> initializePreferencesService() async {
  _sp = await SharedPreferencesWithCache.create(
    cacheOptions: SharedPreferencesWithCacheOptions(
      allowList: Preferences.all.map((x) => x.key).toSet(),
    ),
  );
  Preferences._initializeAll();
}

abstract final class Preferences {
  static const Preference<int> currentUserId =
      _IntPreference('currentUserId', -1);
  static const Preference<bool> isSomeOneLoggedIn =
      _BoolPreference('isSomeOneLoggedIn', false);
  static const Preference<int> homeScreenNavBarSelection =
      _IntPreference('homeScreenNavBarSelection', 0);

  static const Set<Preference> all = {
    currentUserId,
    isSomeOneLoggedIn,
    homeScreenNavBarSelection,
  };

  static void _initializeAll() {
    for (final pref in Preferences.all) {
      if (!_sp.containsKey(pref.key)) pref.value = pref.defaultValue;
    }
  }
}

abstract class Preference<T> {
  final String key;
  final T defaultValue;

  T get value;
  set value(T value);

  const Preference(this.key, this.defaultValue);
}

class _IntPreference extends Preference<int> {
  const _IntPreference(super.key, super.defaultValue);

  @override
  int get value => _sp.getInt(key)!;
  @override
  set value(int value) {
    _sp.setInt(key, value);
  }
}

class _BoolPreference extends Preference<bool> {
  const _BoolPreference(super.key, super.defaultValue);

  @override
  bool get value => _sp.getBool(key)!;
  @override
  set value(bool value) {
    _sp.setBool(key, value);
  }
}
