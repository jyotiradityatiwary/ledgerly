import 'package:flutter/material.dart';
import 'package:ledgerly/views/home_page.dart';
import 'package:ledgerly/views/login_checker/view_model.dart';
import 'package:ledgerly/views/login_screen/view.dart';

class LoginChecker extends StatelessWidget {
  const LoginChecker({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = LoginCheckerViewModel();
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) =>
          viewModel.isLoggedIn ? HomePage() : LoginScreen(),
    );
  }
}
