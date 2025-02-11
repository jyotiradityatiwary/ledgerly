import 'package:flutter/material.dart';
import 'package:ledgerly/notifiers/preferences_notifier.dart';
import 'package:ledgerly/view_models/login_screen.dart';
import 'package:ledgerly/views/post_login/home_screen.dart';
import 'package:ledgerly/views/login_screen.dart';
import 'package:provider/provider.dart';

class LoginChecker extends StatelessWidget {
  LoginChecker({super.key});

  final _loginScreenNavKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final loginNavigator = Navigator(
      key: _loginScreenNavKey,
      onGenerateRoute: (route) => MaterialPageRoute(
          settings: route, builder: (context) => LoginScreen()),
    );
    final loginViewModelProvider = ChangeNotifierProvider<LoginScreenViewModel>(
      create: (context) => LoginScreenViewModel(),
      child: loginNavigator,
    );

    return Consumer<PreferencesNotifier>(
      builder: (final context, final preferencesNotifier, final child) =>
          preferencesNotifier.user == null ? loginViewModelProvider : child!,
      child: HomeScreen(),
    );
  }
}
