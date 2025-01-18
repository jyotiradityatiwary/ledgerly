import 'package:flutter/material.dart';
import 'package:ledgerly/views/login_screen/view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserPicker(),
      appBar: AppBar(
        title: Text("Pick a user"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text("New User"),
        icon: Icon(Icons.add),
        isExtended: true,
      ),
    );
  }
}

class UserPicker extends StatelessWidget {
  const UserPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = UserPickerViewModel();
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) => ListView(
        children: <Widget>[
              for (final user in viewModel.userList)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(user.name),
                  ),
                )
            ] +
            [
              const SizedBox(
                height: 80,
              )
            ],
      ),
    );
  }
}
