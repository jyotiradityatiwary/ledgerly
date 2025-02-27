import 'package:flutter/material.dart';
import 'package:ledgerly/notifiers/account_notifier.dart';
import 'package:ledgerly/notifiers/preferences_notifier.dart';
import 'package:ledgerly/view_models/login_screen.dart';
import 'package:ledgerly/views/post_login/home_screen.dart';
import 'package:ledgerly/views/login_screen.dart';
import 'package:provider/provider.dart';

class LoginChecker extends StatelessWidget {
  LoginChecker({super.key});

  final _loginScreenNavKey = GlobalKey<NavigatorState>();
  final _homeScreenNavKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final loginNavigator = Navigator(
      key: _loginScreenNavKey,
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: settings,
        builder: (context) => LoginScreen(),
      ),
    );
    final loginViewModelProvider = ChangeNotifierProvider<LoginScreenViewModel>(
      create: (context) => LoginScreenViewModel(),
      child: loginNavigator,
    );

    final homeScreenNavigator = Navigator(
      key: _homeScreenNavKey,
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: settings,
        builder: (context) => HomeScreen(),
      ),
    );

    return ChangeNotifierProvider<PreferencesNotifier>(
      create: (context) => PreferencesNotifier(),
      child: Consumer<PreferencesNotifier>(
        builder: (final context, final preferencesNotifier, final _) {
          final user = preferencesNotifier.user;
          if (user == null) {
            return loginViewModelProvider;
          } else {
            final homeScreenProvider = ChangeNotifierProvider<AccountNotifier>(
              create: (context) => AccountNotifier(user: user),
              child: homeScreenNavigator,
            );
            return homeScreenProvider;
          }
        },
      ),
    );
  }
}
